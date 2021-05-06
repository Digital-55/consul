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

  def destroy
    if @custom_page.destroy
      flash[:notice] = t("admin.custom_pages.destroy.success")
    else
      flash[:notice] = t("admin.custom_pages.destroy.error")
    end
    redirect_to admin_custom_pages_path
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(:title, :slug, :published,
                                        custom_page_modules_attributes: [:id, :type, :position,
                                                                          :subtitle,
                                                                          :claim,
                                                                          :rich_text,
                                                                          :youtube_url,
                                                                          :cta_text, :cta_button, :cta_link,
                                                                          :js_snippet,
                                                                          :custom_image,
                                                                          :disabled, :_destroy],
                                        subtitles_attributes: [:type, :position, :subtitle, :disabled, :_destroy],
                                        claims_attributes: [:type, :position, :claim, :disabled, :_destroy],
                                        rich_texts_attributes: [:type, :position, :rich_text, :disabled, :_destroy],
                                        youtubes_attributes: [:type, :position, :youtube_url, :disabled, :_destroy],
                                        ctas_attributes: [:type, :position, :cta_text, :cta_button, :cta_link, :disabled, :_destroy],
                                        js_snippets_attributes: [:type, :position, :js_snippet, :disabled, :_destroy],
                                        custom_images_attributes: [:type, :position, :custom_image, :disabled, :_destroy]
                                      )
  end

  def set_custom_page
    @custom_page = CustomPage.find(params[:id])
  end
end