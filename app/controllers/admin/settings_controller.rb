class Admin::SettingsController < Admin::BaseController
  include Admin::ManagesProposalSettings

  helper_method :successful_proposal_setting, :successful_proposals,
                :poll_feature_short_title_setting, :poll_feature_description_setting,
                :poll_feature_link_setting, :email_feature_short_title_setting,
                :email_feature_description_setting,
                :poster_feature_short_title_setting, :poster_feature_description_setting

  def index
    all_settings = Setting.all.group_by { |setting| setting.type }
    @configuration_settings = all_settings["configuration"].reject do |setting|
      hidden_settings.include?(setting.key)
    end
    @feature_settings = all_settings["feature"]
    @participation_processes_settings = all_settings["process"]
    @map_configuration_settings = all_settings["map"]
    @proposals_settings = all_settings["proposals"]
    @uploads_settings = all_settings["uploads"]
  end

  def update
    @setting = Setting.find(params[:id])
    @setting.update(settings_params)
    redirect_to request.referer, notice: t("admin.settings.flash.updated")
  end

  def update_map
    Setting["map.latitude"] = params[:latitude].to_f
    Setting["map.longitude"] = params[:longitude].to_f
    Setting["map.zoom"] = params[:zoom].to_i
    redirect_to admin_settings_path, notice: t("admin.settings.index.map.flash.update")
  end

  def update_content_types
    setting = Setting.find(params[:id])
    group = setting.content_type_group
    mime_type_values = content_type_params.keys.map do |content_type|
      Setting.mime_types[group][content_type]
    end
    setting.update value: mime_type_values.join(" ")
    redirect_to admin_settings_path, notice: t("admin.settings.flash.updated")
  end

  private

    def settings_params
      params.require(:setting).permit(:value)
    end

    def content_type_params
      params.permit(:jpg, :png, :gif, :pdf, :doc, :docx, :xls, :xlsx, :csv, :zip, :mp4)
    end

    def hidden_settings
      ["place_name",
       "banner-style.banner-style-one",
       "banner-style.banner-style-two",
       "banner-style.banner-style-three",
       "banner-img.banner-img-one",
       "banner-img.banner-img-two",
       "banner-img.banner-img-three"]
    end
end
