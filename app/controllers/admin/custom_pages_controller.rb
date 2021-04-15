class Admin::CustomPagesController < Admin::BaseController
  # include Translatable

  has_filters %w{all published draft}, only: :index

  def index
    @custom_pages = CustomPage.send(@current_filter).page(params[:page])
  end
end