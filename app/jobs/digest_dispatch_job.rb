class DigestDispatchJob < ApplicationJob
  queue_as :mailers

  def perform
    User.find_each do |user|
      DigestMailer.digest(user).deliver_later
    end
  end
end