require "rails_helper"

RSpec.describe Category, type: :model do
  describe "ファクトリ" do
    it "有効なデータを作れること" do
      expect(build(:category)).to be_valid
    end
  end

  describe "バリデーション" do
    it "nameが空だと無効であること" do
      category = build(:category, name: nil)

      expect(category).to be_invalid
      expect(category.errors[:name]).to be_present
    end

    it "nameが重複していると無効であること" do
      create(:category, name: "テストカテゴリ")
      category = build(:category, name: "テストカテゴリ")

      expect(category).to be_invalid
      expect(category.errors[:name]).to be_present
    end
  end

  describe "関連" do
    it "カテゴリから、属する食材だけを取り出せること" do
      category = create(:category)
      food = create(:food, category: category)
      other_food = create(:food)

      expect(category.foods).to contain_exactly(food)
      expect(category.foods).not_to include(other_food)
    end

    it "食材があるカテゴリは、削除できないこと（外部キーで守られている）" do
      category = create(:category)
      create(:food, category: category)

      expect { category.destroy }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end
end
