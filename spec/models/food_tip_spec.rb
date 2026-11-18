require "rails_helper"

RSpec.describe FoodTip, type: :model do
  describe "ファクトリ" do
    it "有効なデータを作れること" do
      expect(build(:food_tip)).to be_valid
    end
  end

  describe "バリデーション" do
    it "descriptionが空だと無効であること" do
      food_tip = build(:food_tip, description: nil)

      expect(food_tip).to be_invalid
      expect(food_tip.errors[:description]).to be_present
    end

    it "kindが空だと無効であること" do
      food_tip = build(:food_tip, kind: nil)

      expect(food_tip).to be_invalid
      expect(food_tip.errors[:kind]).to be_present
    end

    it "foodが無いと無効であること" do
      food_tip = build(:food_tip, food: nil)

      expect(food_tip).to be_invalid
      expect(food_tip.errors[:food]).to be_present
    end
  end

  describe "kindの許可リスト" do
    %w[appearance weight texture smell other].each do |kind|
      it "#{kind}は有効であること" do
        expect(build(:food_tip, kind: kind)).to be_valid
      end
    end

    it "許可リスト外の値は無効であること" do
      food_tip = build(:food_tip, kind: "invalid_kind")

      expect(food_tip).to be_invalid
      expect(food_tip.errors[:kind]).to be_present
    end

    it "許可リストは、5種類であること（アイコンと種類名の対応に、そろえてある）" do
      expect(FoodTip::KINDS).to eq(%w[appearance weight texture smell other])
    end
  end

  describe "1つの食材につき、最大3つの制約" do
    let(:food) { create(:food) }

    it "3つまでは、作成できること" do
      create_list(:food_tip, 3, food: food)

      expect(food.food_tips.count).to eq(3)
    end

    it "4つ目は、無効で、保存されないこと" do
      create_list(:food_tip, 3, food: food)
      fourth = build(:food_tip, food: food)

      expect(fourth).to be_invalid
      expect(fourth.errors[:base]).to be_present
      expect { fourth.save }.not_to change(FoodTip, :count)
    end

    it "3つある状態でも、既存のポイントを更新できること（自分自身は数えない）" do
      tips = create_list(:food_tip, 3, food: food)

      expect(tips.first.update(description: "更新後の説明")).to be(true)
      expect(tips.first.reload.description).to eq("更新後の説明")
    end

    it "別の食材なら、それぞれ3つ作れること（上限は、食材ごと）" do
      create_list(:food_tip, 3, food: food)
      other_food = create(:food)

      expect(build(:food_tip, food: other_food)).to be_valid
    end

    it "ポイントを1つ削除すると、また追加できること" do
      tips = create_list(:food_tip, 3, food: food)
      tips.first.destroy

      expect(build(:food_tip, food: food)).to be_valid
    end
  end
end
