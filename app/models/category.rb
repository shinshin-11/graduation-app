class Category < ApplicationRecord
  has_many :foods
  validates :name, presence: true, uniqueness: true

  # 画面に並べる順番（登録した順）
  scope :ordered, -> { order(:id) }
end
