FactoryGirl.define do

  factory :user do
    sequence(:email) {|i| "user#{i}@tribunalsdecisions.service.gov.uk"}
    password 'password123'
    password_confirmation 'password123'
  end

  factory :all_judge do
    prefix { Faker::Name.prefix }
    suffix { Faker::Name.suffix }
    surname { Faker::Name.last_name }
  end

  factory :category do
    sequence(:name) {|i| "Category #{i}"}
  end

  factory :subcategory do
    sequence(:name) {|i| "SubCategory #{i}"}
  end


  factory :tribunal do
    sequence(:name) {|i| "Tribunal#{i}" }
    sequence(:code) {|i| "tb#{i}" }
  end

  factory :all_decision do
  end

end
