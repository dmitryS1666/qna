FactoryBot.define do
  factory :rating do
    vote 1
    user
    appraised factory: :question
  end
end