module FoodTipsHelper
  KIND_LABELS = {
    "appearance" => "見た目",
    "weight" => "重さ",
    "texture" => "手ざわり",
    "smell" => "におい",
    "other" => "その他"
  }.freeze

  def food_tip_icon_path(kind)
    "icons/#{kind}.svg"
  end

  def food_tip_label(kind)
    KIND_LABELS.fetch(kind, kind)
  end
end
