require 'rails_helper'

describe NewAnswerDispatchJob do
  let!(:subscribered_user) { create(:user) }
  let!(:question) { create(:question, user: subscribered_user) }
  let!(:answer) {create(:answer, question: question)}

  it 'sends new answer' do
    expect(AnswerMailer).to receive(:notifier).with(answer, subscribered_user).and_call_original
    NewAnswerDispatchJob.perform_now(answer)
  end
end