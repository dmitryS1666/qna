class NewAnswerDispatchJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribers = answer.question.subscribers
    subscribers.find_each do |recipient|
      AnswerMailer.notifier(answer, recipient).deliver_later if !answer.user.owner_of?
    end
  end
end