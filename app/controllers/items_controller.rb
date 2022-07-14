class ItemsController < ApplicationController

  # Get all
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user

  rescue ActiveRecord::RecordNotFound
    render json: {error: "Item not found"}, status: :not_found
  end

  # Find by id

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item, status: :ok, include: :user
    else
      render json: {error: "Item not found"}, status: :not_found
    end
  end

  # Create

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = Item.create(params.permit(:name, :description, :price))
      user.items << item
      render json: item, status: 201
    else
      Item.create(params.permit(:name, :description, :price))
    end
  end

end
