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
  ],

  "さかな" => [
      {
        name: "まぐろ",
        tips: [
          { kind: "appearance", description: "色つやがよく、黒ずんでいないもの" },
          { kind: "appearance", description: "スジが目立たず、きめが細かいもの（刺身用）" },
          { kind: "other", description: "パックに赤い汁（ドリップ）が出ていないもの" }
        ]
      },
      {
        name: "さけ",
        tips: [
          { kind: "appearance", description: "全体につやがあり、オレンジ色が濃いもの" },
          { kind: "appearance", description: "切り口が白っぽく濁っていないもの" },
          { kind: "other", description: "パックに赤い汁（ドリップ）が出ていないもの" }
        ]
      },
      {
        name: "さば",
        tips: [
          { kind: "appearance", description: "背中の模様がくっきりして、光沢があるもの" },
          { kind: "appearance", description: "目が澄んでいて、腹が銀色に光っているもの" },
          { kind: "appearance", description: "身が赤みがかったピンク色で透明感があるもの" }
        ]
      },
      {
        name: "さんま",
        tips: [
          { kind: "appearance", description: "全体に厚みがあり、尾まで太っているもの" },
          { kind: "appearance", description: "腹が銀色に輝き、肛門から内臓が出ていないもの" },
          { kind: "appearance", description: "首の後ろに丸みがあるもの" }
        ]
      },
      {
        name: "いわし",
        tips: [
          { kind: "appearance", description: "傷がなく、背中の模様が鮮やかで、厚み・はりがあるもの" },
          { kind: "appearance", description: "目が澄んでいて、黒目がはっきりしているもの" },
          { kind: "other", description: "パックに赤い汁（ドリップ）が出ていないもの" }
        ]
      }
    ],

  "にく" => [
    {
      name: "牛肉（赤身・切り落とし）",
      tips: [
        { kind: "appearance", description: "鮮やかな赤色で、赤身と脂身の境目がはっきりしているもの" },
        { kind: "other", description: "パックに赤い汁（ドリップ）が出ていないもの" }
      ]
    },
    {
      name: "豚肉（ロース・バラ）",
      tips: [
        { kind: "appearance", description: "つやのある淡いピンク色で、赤身と脂身の境目がはっきりしているもの" },
        { kind: "other", description: "パックに肉汁（ドリップ）が出ていないもの" }
      ]
    },
    {
      name: "鶏肉",
      tips: [
        { kind: "appearance", description: "淡い色で厚みがあり、皮の毛穴が立っているもの" },
        { kind: "texture", description: "指で軽く押したときに、弾力があるもの" },
        { kind: "other", description: "パックに肉汁（ドリップ）が出ていないもの" }
      ]
    },
    {
      name: "ひき肉（牛・豚・合い挽き）",
      tips: [
        { kind: "appearance", description: "鮮やかな赤色でつやがあり、色がくすんでいないもの" },
        { kind: "other", description: "パックの底に赤い汁（ドリップ）がにじんでいないもの" }
      ]
    },
    {
      name: "ひき肉（鶏）",
      tips: [
        { kind: "appearance", description: "淡いピンク色でつやがあり、形がはっきりしているもの" },
        { kind: "other", description: "ベチャッと水っぽくないもの" }
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
