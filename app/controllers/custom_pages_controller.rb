class CustomPagesController < ApplicationController
  include FeatureFlags
  skip_authorization_check
  feature_flag :help_page, if: lambda { params[:id] == "help/index" }

  def show
    @custom_page = CustomPage.published.find_by(slug: params[:slug])
    if @custom_page.present?
      render :show and return
    end

    @static_custom_page = SiteCustomization::Page.published.find_by(slug: params[:slug])
    @banners = Banner.in_section("help_page").with_active
    if @static_custom_page.present?
      @custom_page = @static_custom_page
      @cards = @static_custom_page.cards
      render 'pages/custom_page'
    else
      render action: params[:slug]
    end
    rescue ActionView::MissingTemplate
      head 404, content_type: "text/html"
  end

end