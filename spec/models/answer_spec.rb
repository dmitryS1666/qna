require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body}
  it do
    should validate_length_of(:body).
        is_at_least(2).
        on(:create)
  end
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments)}
  it { should have_many(:ratings)}
  it { should have_many(:comments)}

  it { should accept_nested_attributes_for :attachments}

  describe 'method flag_as_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:second_answer) { create(:answer, user: user, question: question) }

    it 'to flag answer best' do
      answer.flag_as_best
      answer.reload

      expect(answer.best).to be true
      expect(question.answers.where(best: true).count).to eq(1)
    end

    it 'the question can have only one best answer' do
      second_answer.flag_as_best
      second_answer.reload

      expect(question.answers.where(best: true).count).to eq(1)
    end
  end

  let!(:object_name) { :answer }
  it_behaves_like "model_rated"
end