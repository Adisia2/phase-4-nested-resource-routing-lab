# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    @items = Item.includes(:user).where(user_id: params[:user_id])
    render json: @items, include: :user
  end

  def show
    @item = @user.items.find_by(id: params[:id])
    if @item
      render json: @item
    else
      render json: { error: "Item not found" }, status: :not_found
    end
  end

  def create
    @item = @user.items.build(item_params)

    if @item.save
      render json: @item, status: :created
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    begin
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def item_params
    params.permit(:name, :description, :price).merge(user_id: params[:user_id])
  end
end
