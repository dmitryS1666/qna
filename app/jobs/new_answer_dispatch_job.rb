class NewAnswerDispatchJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribers = answer.question.subscribers
    subscribers.find_each do |recipient|
      AnswerMailer.notifier(answer, recipient).deliver_later unless recipient.owner_of?(answer)
    end
  end
end