class DigestDispatchJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.last_day
    User.find_each do |user|
      DigestMailer.digest(user, questions).try(:deliver_later)
    end
  end
end