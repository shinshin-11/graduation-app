FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "テストカテゴリ#{n}" }
  end
end
