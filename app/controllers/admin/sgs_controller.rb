class Admin::SgsController < Admin::BaseController
    respond_to :html, :js

    def index
        @type = params[:type].blank? ? 'search' : params[:type]
        if @type == 'search'
            @sg_generic = ::Sg::Generic.search_settings
            @sg_settings =  ::Sg::Setting.search_settings
        elsif @type == 'order'
            @sg_generic = ::Sg::Generic.order_settings
            @sg_settings = ::Sg::Setting.order_settings
        end
        @sg_settings =  @sg_settings.order(id: :asc)
    end
end