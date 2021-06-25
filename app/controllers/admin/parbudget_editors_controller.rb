class Admin::ParbudgetEditorsController < Admin::BaseController
    load_and_authorize_resource
    has_filters %w[users superadministrators administrators sures_administrators section_administrators 
      organizations officials moderators valuators managers consultants editors parbudget_editors parbudget_readers complan_editors complan_readers]
  
    def index
      @parbudget_editors = Parbudget::Editor.all.page(params[:page])
    end
  
    def destroy
        if !@parbudget_editors.blank?
          if !current_user.blank? && current_user.id == @parbudget_editors.user_id
            flash[:error] = I18n.t("admin.parbudget_editors.administrator.restricted_removal")
          else
            user = User.find(@parbudget_editors.user_id)
            user.profiles_id = nil
            user.save
            @parbudget_editors.destroy
          end
        else
          flash[:error] = I18n.t("admin.parbudget_editors.administrator.restricted_removal")
        end
  
        redirect_to admin_parbudget_editors_path
    rescue
      flash[:error] = I18n.t("admin.parbudget_editors.administrator.restricted_removal")
      redirect_to admin_parbudget_editors_path
    end
  end