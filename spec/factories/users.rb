FactoryBot.define do

  factory :user do
    before(:create, &:skip_confirmation!)

    sequence(:email) { |n| "user-12#{n}@test.ru" }
    password 'pdsfdsfsdfsdfdsfsf'
    password_confirmation 'pdsfdsfsdfsdfdsfsf'
  end
end