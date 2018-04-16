FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Why my transaction not work? #{n} question" }
    body "Because you are not autorized"
    association :user, factory: :user, strategy: :build
  end

  factory :question_with_rating, parent: :question do
    after(:create) { |question| create(:rating, appraised: question)}
  end

  factory :wrong_question, class: "Question" do
    title nil
    body nil
  end
end