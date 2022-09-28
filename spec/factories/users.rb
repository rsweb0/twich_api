# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    email { 'test@example.com' }
    password { 'icpt6gH@' }
    name { 'Test User' }
  end
end
