class Admin::CustomPagesController < Admin::BaseController
  before_action :set_custom_page, only: [:edit, :update, :destroy]
  after_action :set_published, only: [:create, :update]
  after_action :set_user, only: [:create, :update]
  load_and_authorize_resource

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
      redirect_to edit_admin_custom_page_path(@custom_page), notice: t("admin.custom_pages.edit.notice")
    else
      render :edit
    end
  end

  def destroy
    if @custom_page.destroy
      @custom_page.children_pages.update(parent_slug: nil) if @custom_page.children_pages.present?
      flash[:notice] = t("admin.custom_pages.destroy.success")
    else
      flash[:notice] = t("admin.custom_pages.destroy.error")
    end
    redirect_to admin_custom_pages_path
  end


  def draft_preview
    @custom_page = CustomPage.find(params[:custom_page_id])
    render :draft_preview if @custom_page.present?
  end

  private

  def custom_page_params
    params.require(:custom_page).permit(:title, :parent_slug, :slug, :published, :meta_title, :meta_description, :meta_keywords, :canonical, :font_color, :font_type,
                                        custom_page_modules_attributes: [:id, :type, :position,
                                                                          :subtitle,
                                                                          :claim,
                                                                          :rich_text,
                                                                          :youtube_url,
                                                                          :cta_text, :cta_button, :cta_link,
                                                                          :js_snippet,
                                                                          :custom_image, :custom_image_alt,
                                                                          :promo_location_one, :promo_title_one, :promo_description_one, :promo_image_one, :promo_alt_image_one, :promo_link_one,
                                                                          :promo_location_two, :promo_title_two, :promo_description_two, :promo_image_two, :promo_alt_image_two, :promo_link_two,
                                                                          :promo_location_three, :promo_title_three, :promo_description_three, :promo_image_three, :promo_alt_image_three, :promo_link_three,
                                                                          :disabled, :_destroy],
                                        subtitles_attributes: [:type, :position, :subtitle, :disabled, :_destroy],
                                        claims_attributes: [:type, :position, :claim, :disabled, :_destroy],
                                        rich_texts_attributes: [:type, :position, :rich_text, :disabled, :_destroy],
                                        youtubes_attributes: [:type, :position, :youtube_url, :disabled, :_destroy],
                                        ctas_attributes: [:type, :position, :cta_text, :cta_button, :cta_link, :disabled, :_destroy],
                                        js_snippets_attributes: [:type, :position, :js_snippet, :disabled, :_destroy],
                                        custom_images_attributes: [:type, :position, :custom_image, :custom_image_alt, :disabled, :_destroy],
                                        promotionals_attributes: [:type, :position,
                                                                  :promo_location_one, :promo_title_one, :promo_description_one, :promo_image_one, :promo_alt_image_one, :promo_link_one,
                                                                  :promo_location_two, :promo_title_two, :promo_description_two, :promo_image_two, :promo_alt_image_two, :promo_link_two,
                                                                  :promo_location_three, :promo_title_three, :promo_description_three, :promo_image_three, :promo_alt_image_three, :promo_link_three,
                                                                  :disabled, :_destroy]
                                      )
  end

  def set_custom_page
    @custom_page = CustomPage.find(params[:id])
  end

  def set_published
    parent_page = CustomPage.find_by(slug: @custom_page.parent_slug)
    if parent_page && custom_page_params[:published] == "true"
      parent_page.update(published: true)
    end

    children_pages = @custom_page.children_pages
    if children_pages && custom_page_params[:published] == "false"
      children_pages.published.update(published: false)
    end
  end

  def set_user
    @custom_page.update(user: current_user) if @custom_page.user != current_user
  end
end