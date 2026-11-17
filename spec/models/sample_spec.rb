require "rails_helper"

RSpec.describe "RSpecとFactoryBotの動作確認" do
  it "RSpecが動く" do
    expect(1 + 1).to eq(2)
  end

  it "テスト用DBに接続できる" do
    expect { Category.count }.not_to raise_error
  end

  it "FactoryBotのメソッドが使える" do
    expect(self).to respond_to(:create, :build)
  end
end
