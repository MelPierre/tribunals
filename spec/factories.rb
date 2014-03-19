FactoryGirl.define do

  factory :user do
    sequence(:email) {|i| "user#{i}@tribunalsdecisions.service.gov.uk"}
    password 'password123'
    password_confirmation 'password123'
  end
  
end