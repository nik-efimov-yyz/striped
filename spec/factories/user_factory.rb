FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }

    trait(:active) { status "active" }
    trait(:trialing) { status "trialing" }
    trait(:canceled) { status "canceled" }
    trait(:past_due) { status "past_due" }
    trait(:unpaid) { status "unpaid" }

  end
end