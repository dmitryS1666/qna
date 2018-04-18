require 'rails_helper'

RSpec.describe DigestDispatchJob, type: :job do
  let!(:users) { create_list(:user, 5) }
  let!(:questions) { create_list(:question, 5, user: users.first) }

  it 'sends digest to all users' do
    users.each do |recipient|
      expect(DigestMailer).to receive(:digest).with(recipient, questions)
    end
    DigestDispatchJob.perform_now
  end


end