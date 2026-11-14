# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
[ "やさい・くだもの", "さかな", "にく" ].each do |name|
  Category.find_or_create_by!(name: name)
end

foods_by_category = {
  "やさい・くだもの" => [
    {
      name: "トマト",
      tips: [
        { kind: "weight", description: "ずっしり重いもの" },
        { kind: "appearance", description: "ヘタが濃い緑で、色にムラがなく、皮がピンと張っているもの" }
      ]
    },
    {
      name: "キャベツ",
      tips: [
        { kind: "appearance", description: "葉がしっかり巻いていて、外側の葉がみずみずしいもの" },
        { kind: "weight", description: "ずっしり重みのあるもの" }
      ]
    },
    {
      name: "白菜",
      tips: [
        { kind: "appearance", description: "葉が生き生きしていて、切り口が平らなもの" },
        { kind: "weight", description: "ずっしり重いもの" }
      ]
    },
    {
      name: "レタス",
      tips: [
        { kind: "appearance", description: "玉レタスは、巻きがふんわりして、固すぎないもの" },
        { kind: "texture", description: "リーフレタスは、葉にハリがあって、みずみずしいもの" }
      ]
    },
    {
      name: "なす",
      tips: [
        { kind: "appearance", description: "紫色が濃く、切り口が新しいもの" },
        { kind: "texture", description: "皮にハリとつやがあり、ヘタのとげがチクッとするもの" },
        { kind: "weight", description: "手に取って、ずっしり重いもの" }
      ]
    }
  ]
}

foods_by_category.each do |category_name, foods|
  category = Category.find_by!(name: category_name)

  foods.each do |food_data|
    ActiveRecord::Base.transaction do
      food = Food.find_or_initialize_by(name: food_data[:name])
      food.category = category
      food.save!

      food.food_tips.destroy_all
      food_data[:tips].each { |tip| food.food_tips.create!(tip) }
    end
  end
end
