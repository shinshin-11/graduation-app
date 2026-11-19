require "rails_helper"

RSpec.describe "対応ブラウザ", type: :request do
  let(:old_safari) do
    "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
  end

  let(:modern_chrome) do
    "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36"
  end

  it "古いブラウザ（Safari 15）には、日本語の案内ページ（406）が表示されること" do
    get root_path, headers: { "User-Agent" => old_safari }

    expect(response).to have_http_status(:not_acceptable)
    expect(response.body).to include("このアプリに対応していません")
  end

  it "新しいブラウザ（Chrome）では、通常どおり表示されること" do
    get root_path, headers: { "User-Agent" => modern_chrome }

    expect(response).to have_http_status(:ok)
  end
end
