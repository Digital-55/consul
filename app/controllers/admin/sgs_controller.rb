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

    def create_generic
        type = params[:type].blank? ? 'search' : params[:type]

        if type == 'search'
            sg_generic = ::Sg::Generic.search_settings
            param_permit = permit_generic_data_search(params)
            sg_table_field = ::Sg::TableField.new(sgeneric: sg_generic, table_name: param_permit[:generic_table_name], field_name: param_permit[:generic_field_name] )

            if sg_table_field.save
                redirect_to admin_sgs_path(type: type.to_s),  notice: I18n.t("admin.sg.form.notice_generic")
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic")
                redirect_to admin_sgs_path(type: type.to_s)
            end
        elsif type == 'order'
            sg_generic = ::Sg::Generic.order_settings
            param_permit = permit_generic_data_order(params)

            sg_order_field = ::Sg::TableOrder.new(sg_generic: sg_generic, table_name: param_permit[:generic_table_name], order: param_permit[:generic_order] )

            if sg_order_field.save
                redirect_to admin_sgs_path(type: type.to_s),  notice: I18n.t("admin.sg.form.notice_generic_order")
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic_order")
                redirect_to admin_sgs_path(type: type.to_s)
            end
        end
    rescue
        flash[:error] =  type == 'search' ? I18n.t("admin.sg.form.error_generic") : I18n.t("admin.sg.form.error_generic_order") 
        redirect_to admin_sgs_path(type: type.to_s)
    end


    def delete_generic
        type = params[:type].blank? ? 'search' : params[:type]
        if type == 'search'
            sg_table_field = ::Sg::TableField.find(params[:id])
            if sg_table_field.destroy
                redirect_to admin_sgs_path(type: type.to_s),  notice:  I18n.t("admin.sg.form.notice_generic_destroy") 
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic_destroy")
                redirect_to admin_sgs_path(type: type.to_s)
            end
        elsif type == 'order'
            sg_order_field = ::Sg::TableOrder.find(params[:id])
            if sg_order_field.destroy
                redirect_to admin_sgs_path(type: type.to_s),  notice: I18n.t("admin.sg.form.notice_generic_order_destroy") 
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic_order_destroy")
                redirect_to admin_sgs_path(type: type.to_s)
            end
        end
    rescue
        flash[:error] = type == 'search' ? I18n.t("admin.sg.form.error_generic_destroy") : I18n.t("admin.sg.form.error_generic_order_destroy")
        redirect_to admin_sgs_path(type: type.to_s)
    end

    private

    def permit_generic_data_search(parameters)
        parameters.permit(:generic_table_name, :generic_field_name)
    end

    def permit_generic_data_order(parameters)
        parameters.permit(:generic_table_name, :generic_order)
    end
end