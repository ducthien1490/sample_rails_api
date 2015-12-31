# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'howtolearn@abc.com'
    password '123456789'
    password_confirmation '123456789'
  end
end
