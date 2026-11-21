require "rails_helper"

RSpec.describe FoodTipsHelper, type: :helper do
  describe "種類（kind）ごとの表示名とアイコン" do
    FoodTip::KINDS.each do |kind|
      it "#{kind}に、日本語の表示名が決まっていること" do
        expect(helper.food_tip_label(kind)).not_to eq(kind)
      end

      it "#{kind}に、アイコンのファイルがあること" do
        path = Rails.root.join("app/assets/images", helper.food_tip_icon_path(kind))

        expect(File.exist?(path)).to be(true)
      end
    end

    it "表示名の表に、許可リストにない種類が、混ざっていないこと" do
      expect(FoodTipsHelper::KIND_LABELS.keys).to match_array(FoodTip::KINDS)
    end
  end
end
