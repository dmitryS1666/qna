class NewAnswerDispatchJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribers = answer.question.subscribers
    subscribers.find_each do |recipient|
      AnswerMailer.notifier(answer, recipient).try(:deliver_later) unless answer.user == recipient
    end
  end
end