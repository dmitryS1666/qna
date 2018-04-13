require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: user) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("question/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions/', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: user) }
      let!(:comment) { create(:comment, commented: question, user: question.user) }
      let!(:attach) { create(:attachment, attachable: question) }
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}") }
      end
      context 'comments' do
        it { expect(response.body).to have_json_size(1).at_path("comments") }

        %w(id body created_at).each do |attr|
          it { expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}") }
        end
      end
      context 'attachments' do
        it { expect(response.body).to have_json_size(1).at_path("attachments") }

        it { expect(response.body).to be_json_eql(attach.file.to_json).at_path("attachments/0/file") }
      end

    end
  end

  describe 'GET /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/', params: { action: :create, format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions/', params: { action: :create, format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token, question: attributes_for(:question) } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'Check count of question after create' do
        expect{ post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token, question: attributes_for(:question) } }.to change { Question.count }.by(1)
      end

    end
  end

end