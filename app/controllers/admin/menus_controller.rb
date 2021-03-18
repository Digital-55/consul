class Admin::MenusController < Admin::BaseController
  include Translatable

  has_filters %w{all header footer}, only: :index

  def index
    @menus =  Menu.send(@current_filter).page(params[:page])
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      redirect_to admin_menus_path, notice: t("admin.menus.create.notice")
    else
      render :new
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:title, :section, :enabled)
  end
end