FactoryBot.define do
  factory :comment do
    body "MyText"
    user
    commented factory: :question
  end

  factory :wrong_comment, class: "Comment" do
    body nil
    user
    commented factory: :question
  end
end