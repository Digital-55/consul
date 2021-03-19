class Admin::SgsController < Admin::BaseController
    respond_to :html, :js

    before_action :load_setting, only: [ :delete_setting, :update_setting, :generate_table_setting]
    before_action :load_type

    def index
        if @type == 'search'
            @sg_generic = ::Sg::Generic.search_settings
            @sg_settings =  ::Sg::Setting.search_settings
        elsif @type == 'order'
            @sg_generic = ::Sg::Generic.order_settings
            @sg_settings = ::Sg::Setting.order_settings
        end
        @sg_settings =  @sg_settings.order(id: :asc) if !@sg_settings.blank?
    rescue
        @type = 'search'
        @sg_generic = nil
        @sg_settings = nil
    end

    def create_generic
        @type = params[:type].blank? ? 'search' : params[:type]
        if @type == 'search'
            sg_generic = ::Sg::Generic.search_settings
            param_permit = permit_generic_data_search(params)
            sg_table_field = ::Sg::TableField.new(sgeneric: sg_generic, table_name: param_permit[:generic_table_name], field_name: param_permit[:generic_field_name] )

            if sg_table_field.save
                redirect_to admin_sgs_path(type: @type.to_s),  notice: I18n.t("admin.sg.form.notice_generic")
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic")
                redirect_to admin_sgs_path(type: @type.to_s)
            end
        elsif @type == 'order'
            sg_generic = ::Sg::Generic.order_settings
            param_permit = permit_generic_data_order(params)

            sg_order_field = ::Sg::TableOrder.new(sg_generic: sg_generic, table_name: param_permit[:generic_table_name], order: param_permit[:generic_order] )

            if sg_order_field.save
                redirect_to admin_sgs_path(type: @type.to_s),  notice: I18n.t("admin.sg.form.notice_generic_order")
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic_order")
                redirect_to admin_sgs_path(type: @type.to_s)
            end
        end
    rescue
        flash[:error] =  @type == 'search' ? I18n.t("admin.sg.form.error_generic") : I18n.t("admin.sg.form.error_generic_order") 
        redirect_to admin_sgs_path(type: @type.to_s)
    end


    def delete_generic
        @type = params[:type].blank? ? 'search' : params[:type]
        if @type == 'search'
            sg_table_field = ::Sg::TableField.find(params[:id])
            if sg_table_field.destroy
                redirect_to admin_sgs_path(type: @type.to_s),  notice:  I18n.t("admin.sg.form.notice_generic_destroy") 
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic_destroy")
                redirect_to admin_sgs_path(type: @type.to_s)
            end
        elsif @type == 'order'
            sg_order_field = ::Sg::TableOrder.find(params[:id])
            if sg_order_field.destroy
                redirect_to admin_sgs_path(type: @type.to_s),  notice: I18n.t("admin.sg.form.notice_generic_order_destroy") 
            else
                flash[:error] = I18n.t("admin.sg.form.error_generic_order_destroy")
                redirect_to admin_sgs_path(type: @type.to_s)
            end
        end
    rescue
        flash[:error] = @type == 'search' ? I18n.t("admin.sg.form.error_generic_destroy") : I18n.t("admin.sg.form.error_generic_order_destroy")
        redirect_to admin_sgs_path(type: @type.to_s)
    end

    def generate_table_setting
        @type = params["#{params[:id]}_type".to_sym]
        param_permit = {table_name: params["#{params[:id]}_table_name".to_sym], field_name: params["#{params[:id]}_field_name".to_sym]}
        sg_table_field = ::Sg::TableField.new(sgeneric: @sg_settings, table_name: param_permit[:table_name], field_name: param_permit[:field_name] )

        if sg_table_field.save
            redirect_to admin_sgs_path(type: @type.to_s),  notice: @type == 'search' ? I18n.t("admin.sg.form.notice_generic") : I18n.t("admin.sg.form.notice_generic_order")
        else
            flash[:error] = @type == 'search' ? I18n.t("admin.sg.form.error_generic") : I18n.t("admin.sg.form.error_generic_order")
            redirect_to admin_sgs_path(type: @type.to_s)
        end
    rescue
        flash[:error] =  @type == 'search' ? I18n.t("admin.sg.form.error_generic") : I18n.t("admin.sg.form.error_generic_order") 
        redirect_to admin_sgs_path(type: @type.to_s)
    end

    def delete_table_setting
        @type = @sg_settings.setting_type
        sg_table_field = ::Sg::TableField.find(params[:id])
        if sg_table_field.destroy
            redirect_to admin_sgs_path(type: @type.to_s),  notice:  @type == 'search' ? I18n.t("admin.sg.form.notice_table_search_destroy") : I18n.t("admin.sg.form.notice_table_order_destroy")
        else
            flash[:error] = @type == 'search' ? I18n.t("admin.sg.form.error_table_search_destroy") : I18n.t("admin.sg.form.error_table_order_destroy")
            redirect_to admin_sgs_path(type: @type.to_s)
        end
    rescue
        flash[:error] = @type == 'search' ? I18n.t("admin.sg.form.error_table_search_destroy") : I18n.t("admin.sg.form.error_table_order_destroy")
        redirect_to admin_sgs_path(type: @type.to_s)
    end

    def generate_setting
        @type = params[:type].blank? ? 'search' : params[:type]
        sg_table_field = ::Sg::Setting.new(setting_type: @type)
        if sg_table_field.save(:validate => false)
            redirect_to admin_sgs_path(type: @type.to_s),  notice: @type == 'search' ? I18n.t("admin.sg.form.avanced.notice_search") : I18n.t("admin.sg.form.avanced.notice_order") 
        else
            flash[:error] = @type == 'search' ? I18n.t("admin.sg.form.avanced.error_search") : I18n.t("admin.sg.form.avanced.error_order")
            redirect_to admin_sgs_path(type: @type.to_s)
        end
    rescue
        flash[:error] = @type == 'search' ? I18n.t("admin.sg.form.avanced.error_search") : I18n.t("admin.sg.form.avanced.error_order")
        redirect_to admin_sgs_path(type: @type.to_s)
    end

    def update_setting
        @type = params[:type].blank? ? 'search' : params[:type]
        #falta por implementar



    end

    def delete_setting
        type = @sg_settings.setting_type
        if @sg_settings.destroy
            redirect_to admin_sgs_path(type: type.to_s),  notice:  type == 'search' ? I18n.t("admin.sg.form.avanced.notice_search_destroy") : I18n.t("admin.sg.form.avanced.notice_order_destroy")
        else
            flash[:error] =  type == 'search' ? I18n.t("admin.sg.form.avanced.error_search_destroy") : I18n.t("admin.sg.form.avanced.error_order_destroy")
            redirect_to admin_sgs_path(type: type.to_s)
        end
    rescue
        flash[:error] =  type == 'search' ? I18n.t("admin.sg.form.avanced.error_search_destroy") : I18n.t("admin.sg.form.avanced.error_order_destroy")
        redirect_to admin_sgs_path(type: type.to_s)
    end

    private

    def load_setting
        @sg_settings = ::Sg::Setting.find(params[:id])
    end

    def load_type
        @type = params[:type].blank? ? 'search' : params[:type]
    end

    def permit_generic_data_search(parameters)
        parameters.permit(:generic_table_name, :generic_field_name)
    end

    def permit_generic_data_order(parameters)
        parameters.permit(:generic_table_name, :generic_order)
    end

    def permit_data_field(parameters)
        parameters.permit(:table_name, :field_name)
    end
end