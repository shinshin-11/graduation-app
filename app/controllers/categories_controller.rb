class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @foods = @category.foods.ordered
  end
end
