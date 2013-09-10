# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feed do
    sequence(:name) {|n| "Feed Name #{n}" }
    sequence(:slug) {|n| "feed_slug_#{n}" }
    description "MyText"
    user
  end
end
