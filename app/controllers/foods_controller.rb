class FoodsController < ApplicationController
  def show
    @food = Food.find(params[:id])
    @food_tips = @food.food_tips.order(:id)
  end
end
