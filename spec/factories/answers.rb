FactoryBot.define do
  factory :answer do
    body "All is a dust"
    question
    user
  end

  factory :wrong_answer, class: "Answer" do
    body nil
  end
end