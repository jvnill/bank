FactoryGirl.define do
  factory :connected_app do
    association :user
    name 'App'
    redirect_url 'localhost:3000'
  end

  factory :transaction do
    association :connected_app
    price 100
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
  end
end
