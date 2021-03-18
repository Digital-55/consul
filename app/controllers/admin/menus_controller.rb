class Admin::MenusController < Admin::BaseController
  include Translatable
  before_action :set_menu, only: [:edit, :update, :destroy]

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

  def edit; end

  def update
    if @menu.update(menu_params)
      redirect_to admin_menus_path, notice: t("admin.menus.edit.notice")
    else
      render :edit
    end
  end

  def destroy
    if @menu.destroy
      flash[:notice] = t("admin.menus.destroy.success")
    else
      flash[:notice] = t("admin.menus.destroy.error")
    end
    redirect_to admin_menus_path
  end

  private

  def menu_params
    params.require(:menu).permit(:title, :section, :published)
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end
end