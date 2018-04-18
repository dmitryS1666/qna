require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "notify" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { AnswerMailer.notifier(answer, question.user) }

    it "renders the headers" do
      expect(mail.to).to eq([question.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer")
    end
  end
end