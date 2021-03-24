class Admin::MenuItemsController < Admin::BaseController
  before_action :set_menu, only: [:sort]
  def sort
    params[:menu_item].each_with_index do |id, index|
      @menu.menu_items.where(id: id).update_all(position: index + 1 )
    end
    head :ok
  end

  private
  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end