require "rails_helper"

RSpec.describe "カテゴリ画面（食材一覧）", type: :request do
  describe "GET /categories/:id" do
    it "正常に表示され、カテゴリ名が見出しになること" do
      category = create(:category, name: "テストカテゴリ")

      get category_path(category)

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.at_css("h1").text.strip).to eq("テストカテゴリ")
    end

    it "そのカテゴリの食材だけが、idの順に表示されること" do
      category = create(:category)
      first = create(:food, category: category, name: "テスト食材A")
      second = create(:food, category: category, name: "テスト食材B")
      create(:food, name: "別カテゴリの食材")

      get category_path(category)

      names = response.parsed_body.css("main li a").map { |link| link.text.strip }
      expect(names).to eq([ first.name, second.name ])
    end

    it "食材のボタンが、その食材の詳細画面へのリンクになっていること" do
      category = create(:category)
      first = create(:food, category: category)
      second = create(:food, category: category)

      get category_path(category)

      hrefs = response.parsed_body.css("main li a").map { |link| link["href"] }
      expect(hrefs).to eq([ food_path(first), food_path(second) ])
    end

    it "「← トップへもどる」が、TOPへのリンクになっていること" do
      category = create(:category)

      get category_path(category)

      link = response.parsed_body.css("main a").find { |a| a.text.strip == "← トップへもどる" }
      expect(link).not_to be_nil
      expect(link["href"]).to eq(root_path)
    end

    it "食材が1件もないとき、準備中のメッセージが出て、エラーにならないこと" do
      category = create(:category)

      get category_path(category)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("準備中")
      expect(response.parsed_body.css("main li")).to be_empty
    end

    it "存在しないカテゴリは、404（見つかりません）になること" do
      get category_path(id: 999_999)

      expect(response).to have_http_status(:not_found)
    end
  end
end
