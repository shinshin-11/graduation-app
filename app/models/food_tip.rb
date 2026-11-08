class FoodTip < ApplicationRecord
  KINDS = %w[appearance weight texture smell other].freeze
  MAX_PER_FOOD = 3

  belongs_to :food

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :description, presence: true
  validate :food_tips_limit

  private

    def food_tips_limit
      return if food.blank?

      others = food.food_tips.where.not(id: id).count
      return if others < MAX_PER_FOOD

      errors.add(:base, "1つの食材につきポイントは#{MAX_PER_FOOD}つまでです")
    end
end
