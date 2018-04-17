class NewAnswerDispatchJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscriptions.all.each do |subscription|
      AnswerMailer.notifier(answer, subscription.user).deliver_later if answer.user != subscription.user
    end
  end
end