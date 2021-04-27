class Admin::MenuItemsController < Admin::BaseController
  before_action :set_menu, only: [:sort]
  before_action :set_menu_item, only: [:update, :destroy]

  def sort
    if params[:menu_item].present?
      params[:menu_item].each_with_index do |id, index|
        @menu.menu_items.where(id: id).update_all(position: index + 1, parent_item_id: params[:parent_item_id]  )
      end
    end
    head :ok
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      render json: {menu_item: @menu_item}
    else
      render json: { errors: @menu_item.errors.messages, menu_item: @menu_item }
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: {menu_item: @menu_item}
    else
      render json: { errors: @menu_item.errors.messages, menu_item: @menu_item }
    end
  end

  def destroy
    subitems = MenuItem.where(parent_item_id: @menu_item.id)
    subitems.destroy_all
    @menu_item.destroy
    head :ok
  end

  private
  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.permit(:id, :title, :url, :position, :page_link, :item_type, :target_blank, :parent_item_id, :menu_id, :editable, :disabled)
  end
end