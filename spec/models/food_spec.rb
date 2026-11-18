require "rails_helper"

RSpec.describe Food, type: :model do
  describe "ファクトリ" do
    it "有効なデータを作れること" do
      expect(build(:food)).to be_valid
    end
  end

  describe "バリデーション" do
    it "nameが空だと無効であること" do
      food = build(:food, name: nil)

      expect(food).to be_invalid
      expect(food.errors[:name]).to be_present
    end

    it "nameが重複していると無効であること" do
      create(:food, name: "テスト食材")
      food = build(:food, name: "テスト食材")

      expect(food).to be_invalid
      expect(food.errors[:name]).to be_present
    end

    it "別のカテゴリでも、同じ名前は使えないこと（名前は全体で一意）" do
      create(:food, name: "テスト食材")
      food = build(:food, name: "テスト食材", category: create(:category))

      expect(food).to be_invalid
      expect(food.errors[:name]).to be_present
    end

    it "categoryが無いと無効であること" do
      food = build(:food, category: nil)

      expect(food).to be_invalid
      expect(food.errors[:category]).to be_present
    end
  end

  describe "削除時の挙動" do
    it "食材を削除すると、紐づくポイントも一緒に削除されること" do
      food = create(:food)
      create_list(:food_tip, 2, food: food)

      expect { food.destroy }.to change(FoodTip, :count).by(-2)
    end

    it "他の食材のポイントは、削除されないこと" do
      food = create(:food)
      other_tip = create(:food_tip)

      food.destroy

      expect(FoodTip.exists?(other_tip.id)).to be(true)
    end
  end
end
