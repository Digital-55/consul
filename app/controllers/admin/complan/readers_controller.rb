class Admin::Complan::ReadersController < Admin::BaseController
  load_and_authorize_resource :reader, class: "Complan::Reader"
  has_filters %w[users superadministrators administrators sures_administrators section_administrators 
    organizations officials moderators valuators managers consultants editors editors_parbudget readers_parbudget  ]

  def index
    @complan_readers = Complan::Reader.all.page(params[:page])
  end

  def destroy
    begin
      @complan_reader = Complan::Reader.find(params[:id])
      if !@complan_reader.blank?
        if !current_user.blank? && current_user.id == @complan_reader.user_id
          flash[:error] = I18n.t("admin.complan_readers.administrator.restricted_removal")
        else
          user = User.find(@complan_reader.user_id)
          user.profiles_id = nil
          user.save
          @complan_reader.destroy
        end
      else
        flash[:error] = I18n.t("admin.complan_readers.administrator.restricted_removal")
      end

      redirect_to admin_complan_readers_path
    rescue
      flash[:error] = I18n.t("admin.complan_readers.administrator.restricted_removal")
      redirect_to admin_complan_readers_path
    end
  end
  
end
