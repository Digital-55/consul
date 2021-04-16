class Admin::CustomPagesController < Admin::BaseController
  before_action :set_custom_page, only: [:edit, :update, :destroy]

  has_filters %w{all published draft}, only: :index

  def index
    @custom_pages = CustomPage.send(@current_filter).page(params[:page])
  end

  def new
    @custom_page = CustomPage.new
  end

  def create
    @custom_page = CustomPage.new(custom_page_params)
    if @custom_page.save
      redirect_to edit_admin_custom_page_path(@custom_page), notice: t("admin.custom_pages.create.notice")
    else
      render :new
    end
  end

  def edit; end

  def update
    if @custom_page.update(custom_page_params)
      redirect_to admin_custom_pages_path, notice: t("admin.custom_pages.edit.notice")
    else
      render :edit
    end
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(:title, :slug, :published)
  end

  def set_custom_page
    @custom_page = CustomPage.find(params[:id])
  end
end