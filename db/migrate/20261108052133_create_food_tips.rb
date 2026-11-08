class CreateFoodTips < ActiveRecord::Migration[8.1]
  def change
    create_table :food_tips do |t|
      t.references :food, null: false, foreign_key: true
      t.string :kind, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
