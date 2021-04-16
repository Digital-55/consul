class Admin::CustomPagesController < Admin::BaseController
  # include Translatable

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
      redirect_to edit_admin_custom_page_path(@custom_page), notice: t("admin.custom_page.create.notice")
    else
      render :new
    end
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(:title, :slug, :published)
  end
end