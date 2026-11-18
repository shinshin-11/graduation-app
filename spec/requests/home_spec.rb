require "rails_helper"

RSpec.describe "TOP画面", type: :request do
  describe "GET /" do
    it "正常に表示され、売り場を選ぶ案内の見出しが出ること" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.at_css("h1").text.strip).to eq("売り場を選んでください")
    end

    it "カテゴリが、idの順（登録した順）に、ボタンとして並ぶこと" do
      first = create(:category, name: "テストカテゴリA")
      second = create(:category, name: "テストカテゴリB")
      third = create(:category, name: "テストカテゴリC")

      get root_path

      names = response.parsed_body.css("nav a").map { |link| link.text.strip }
      expect(names).to eq([ first.name, second.name, third.name ])
    end

    it "各ボタンが、そのカテゴリの画面へのリンクになっていること" do
      first = create(:category)
      second = create(:category)

      get root_path

      hrefs = response.parsed_body.css("nav a").map { |link| link["href"] }
      expect(hrefs).to eq([ category_path(first), category_path(second) ])
    end

    it "カテゴリが1件もなくても、エラーにならないこと" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.css("nav a")).to be_empty
    end
  end

  describe "共通レイアウト" do
    it "ヘッダーのアプリ名が、TOPへのリンクになっていること" do
      get root_path

      link = response.parsed_body.at_css("header a")
      expect(link.text.strip).to eq("3秒めきき")
      expect(link["href"]).to eq(root_path)
    end

    it "日本語のページで、タイトルが「3秒めきき」であること" do
      get root_path

      expect(response.parsed_body.at_css("html")["lang"]).to eq("ja")
      expect(response.parsed_body.at_css("title").text.strip).to eq("3秒めきき")
    end
  end
end
