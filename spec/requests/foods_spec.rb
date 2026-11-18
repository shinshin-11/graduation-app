require "rails_helper"

RSpec.describe "食材詳細画面", type: :request do
  describe "GET /foods/:id" do
    it "正常に表示され、食材名が見出しになること" do
      food = create(:food, name: "テスト食材")

      get food_path(food)

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.at_css("h1").text.strip).to eq("テスト食材")
    end

    it "ポイントが、種類名と説明つきで、idの順に表示されること" do
      food = create(:food)
      create(:food_tip, food: food, kind: "appearance", description: "見た目の説明")
      create(:food_tip, food: food, kind: "weight", description: "重さの説明")
      create(:food_tip, food: food, kind: "smell", description: "においの説明")

      get food_path(food)

      tips = response.parsed_body.css("main li").map { |li| li.text.squish }
      expect(tips).to eq([ "見た目 見た目の説明", "重さ 重さの説明", "におい においの説明" ])
    end

    it "種類ごとのアイコンが、表示されること" do
      food = create(:food)
      create(:food_tip, food: food, kind: "appearance")
      create(:food_tip, food: food, kind: "texture")

      get food_path(food)

      sources = response.parsed_body.css("main li img").map { |img| img["src"] }
      expect(sources.size).to eq(2)
      expect(sources[0]).to include("icons/appearance")
      expect(sources[1]).to include("icons/texture")
    end

    it "他の食材のポイントは、表示されないこと" do
      food = create(:food)
      create(:food_tip, food: food, description: "この食材の説明")
      create(:food_tip, description: "別の食材の説明")

      get food_path(food)

      expect(response.body).to include("この食材の説明")
      expect(response.body).not_to include("別の食材の説明")
    end

    it "ポイントが1件もないとき、準備中のメッセージが出て、エラーにならないこと" do
      food = create(:food)

      get food_path(food)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("準備中")
      expect(response.parsed_body.css("main li")).to be_empty
    end

    it "「← 一覧へもどる」が、所属カテゴリの画面へのリンクになっていること" do
      food = create(:food)

      get food_path(food)

      link = response.parsed_body.css("main a").find { |a| a.text.strip == "← 一覧へもどる" }
      expect(link).not_to be_nil
      expect(link["href"]).to eq(category_path(food.category))
    end

    it "存在しない食材は、404（見つかりません）になること" do
      get food_path(id: 999_999)

      expect(response).to have_http_status(:not_found)
    end
  end
end
