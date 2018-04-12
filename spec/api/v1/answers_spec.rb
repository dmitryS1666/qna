require 'rails_helper'

describe 'Answers API' do
  describe 'GET /show' do
    context 'unauthorized' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user)}

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
  end
end