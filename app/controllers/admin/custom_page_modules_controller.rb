class Admin::CustomPageModulesController < Admin::BaseController
  before_action :set_custom_page, only: [:sort]

  def sort
    params[:custom_page_module].each_with_index do |id, index|
      @custom_page.custom_page_modules.where(id: id).update_all(position: index + 1 )
    end
  end

  private
  def set_custom_page
    @custom_page = CustomPage.find(params[:custom_page_id])
  end

end