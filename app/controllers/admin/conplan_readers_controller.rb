class Admin::ConplanReadersController < Admin::BaseController
    load_and_authorize_resource
    has_filters %w[users superadministrators administrators sures_administrators section_administrators 
    organizations officials moderators valuators managers consultants editors parbudget_editors parbudget_readers conplan_editors conplan_readers]
  
    def index
      @conplan_readers = @conplan_readers.page(params[:page])
    end
  
    def search
      @users = User.search(params[:name_or_email])
                   .includes(:conplan_readers)
                   .page(params[:page])
                   .for_render
    end
  
    def create
      @conplan_readers.user_id = params[:user_id]
      @conplan_readers.save
  
      redirect_to admin_conplan_readers_path
    end
  
    def destroy
        if !@conplan_readers.blank?
          if !current_user.blank? && current_user.id == @conplan_readers.user_id
            flash[:error] = I18n.t("admin.conplan_readers.administrator.restricted_removal")
          else
            user = User.find(@conplan_readers.user_id)
            user.profiles_id = nil
            user.save
            @conplan_readers.destroy
          end
        else
          flash[:error] = I18n.t("admin.conplan_readers.administrator.restricted_removal")
        end
  
        redirect_to admin_conplan_readers_path
    rescue
      flash[:error] = I18n.t("admin.conplan_readers.administrator.restricted_removal")
      redirect_to admin_conplan_readers_path
    end
  end