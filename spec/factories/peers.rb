# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :peer do
    peer_id "MyString"
    info_hash "MyString"
    ip "MyString"
    port 1
    uploaded 1
    downloaded 1
    left 1
    state "MyString"
  end
end
