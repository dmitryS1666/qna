require 'rails_helper'

describe DigestDispatchJob do
  let(:user){ create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }

  it 'sends digest' do
    expect(DigestMailer).to receive(:digest).with(user, questions).and_call_original
    DigestDispatchJob.perform_now
  end
end