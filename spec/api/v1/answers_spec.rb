require 'rails_helper'

describe 'Answers API' do
  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question)}
      let!(:comment) { create(:comment, commented: answer) }
      let!(:attach) { create(:attachment, attachable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w(id body created_at updated_at).each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}") }
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
      get "/api/v1/answers/10", params: {format: :json}.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 5, question: question) }
      let(:answer) {answers.first}

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(5)}

      %w(id body created_at updated_at).each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/0/answers", params: {format: :json}.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { action: :create, access_token: access_token.token, format: :json, answer: attributes_for(:answer)}}

      it { expect(response).to be_success }
      it 'Check count of answers after create' do
        expect{ post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json, access_token: access_token.token, answer: attributes_for(:answer)} }.to change { Answer.count }.by(1)
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/0/answers", { format: :json, action: :create }.merge(options)
    end
  end
end