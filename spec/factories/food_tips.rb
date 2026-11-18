FactoryBot.define do
  factory :food_tip do
    food
    kind { "appearance" }
    description { "テスト用の見分け方" }
  end
end
