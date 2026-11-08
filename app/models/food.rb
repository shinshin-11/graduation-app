class Food < ApplicationRecord
  belongs_to :category
  has_many :food_tips, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
