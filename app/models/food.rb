class Food < ApplicationRecord
  belongs_to :category
  has_many :food_tips, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  # 画面に並べる順番（登録した順）
  scope :ordered, -> { order(:id) }
end
