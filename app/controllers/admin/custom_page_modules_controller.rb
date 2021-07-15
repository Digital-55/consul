class Admin::CustomPageModulesController < Admin::BaseController
  before_action :set_custom_page, only: [:sort, :clear_image]
  before_action :set_custom_page_module, only: [:clear_image]

  def sort
    params[:custom_page_module].each_with_index do |id, index|
      @custom_page.custom_page_modules.where(id: id).update_all(position: index + 1 )
    end
    head :ok
  end

  def clear_image
    type = @custom_page_module.type
    attachment = case type
    when "CTAModule"
      "cta_image"
      # when "CustomImageModule"
      #   "custom_image"
    end
    @custom_page_module.send(attachment).clear
    @custom_page_module.save
    head :ok
  end

  private
  def set_custom_page
    @custom_page = CustomPage.find(params[:custom_page_id])
  end

  def set_custom_page_module
    @custom_page_module = @custom_page.custom_page_modules.find params[:custom_page_module_id]
  end

end