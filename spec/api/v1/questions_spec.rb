require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) {questions.first}
      let!(:answer) { create(:answer, question: question)}

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
    def do_request(options = {})
      get '/api/v1/questions/', params: {format: :json}.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:comment) { create(:comment, commented: question) }
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

    def do_request(options = {})
      get "/api/v1/questions/0", params: {format: :json}.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

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

    def do_request(options = {})
      post '/api/v1/questions/', { format: :json, action: :create }.merge(options)
    end
  end
end