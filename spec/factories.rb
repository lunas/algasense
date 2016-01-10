require 'factory_girl'

FactoryGirl.define do

  factory :rgb do
    red 66
    green 77
    blue 88
    created_at Date.today
  end

end

