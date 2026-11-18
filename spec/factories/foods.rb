FactoryBot.define do
  factory :food do
    sequence(:name) { |n| "テスト食材#{n}" }
    category
  end
end
