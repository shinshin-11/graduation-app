require "rails_helper"

RSpec.describe "画面の遷移", type: :request do
  let!(:category) { create(:category, name: "テストカテゴリ") }
  let!(:food) { create(:food, category: category, name: "テスト食材") }

  before do
    create(:food_tip, food: food, description: "テストの見分け方")
  end

  # 直前に表示した画面から、リンクの文字を手がかりに、リンク先（href）を取り出す
  def href_of(link_text)
    link = response.parsed_body.css("a").find { |a| a.text.strip == link_text }
    expect(link).not_to be_nil
    link["href"]
  end

  it "TOP→カテゴリ画面→食材詳細と、リンクをたどって進めること" do
    get root_path
    get href_of("テストカテゴリ")

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.at_css("h1").text.strip).to eq("テストカテゴリ")

    get href_of("テスト食材")

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.at_css("h1").text.strip).to eq("テスト食材")
    expect(response.body).to include("テストの見分け方")
  end

  it "食材詳細→カテゴリ画面→TOPと、もどるリンクをたどって戻れること" do
    get food_path(food)
    get href_of("← 一覧へもどる")

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.at_css("h1").text.strip).to eq("テストカテゴリ")

    get href_of("← トップへもどる")

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.at_css("h1").text.strip).to eq("売り場を選んでください")
  end
end
