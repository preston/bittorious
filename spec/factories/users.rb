FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email#{n}@example.com" }
    name "Foo Bar"
    password "password"
    password_confirmation "password"
    approved false
    admin false
    confirmed_at {Time.now - 1.day}
    factory :approved_user do
      approved true
    end
    factory :admin_user do
      approved true
      admin true
    end
  end
end
