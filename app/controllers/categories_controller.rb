class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @foods = @category.foods.order(:id)
  end
end
