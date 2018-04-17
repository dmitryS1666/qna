require 'rails_helper'

RSpec.describe NewAnswerDispatchJob, type: :job do
  let!(:subscribered_user) { create(:user) }
  let!(:question) { create(:question, user: subscribered_user) }
  let!(:answer) {create(:answer, question: question)}
  let(:other_users) { create_list(:user, 10) }

  it 'sends new answer' do
    expect(AnswerMailer).to receive(:notifier).with(answer, subscribered_user).and_call_original
    NewAnswerDispatchJob.perform_now(answer)
  end

  it 'sends new answer only subscribers' do
    other_users.each do |not_subscribed_user|
      expect(AnswerMailer).to_not receive(:notifier).with(answer, not_subscribed_user)
    end
    NewAnswerDispatchJob.perform_now(answer)
  end
end