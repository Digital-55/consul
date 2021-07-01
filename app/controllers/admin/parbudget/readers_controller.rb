class Admin::Parbudget::ReadersController < Admin::BaseController
  load_and_authorize_resource :reader, class: "Parbudget::Reader"
    has_filters %w[users superadministrators administrators sures_administrators section_administrators 
      organizations officials moderators valuators managers consultants editors editors_parbudget readers_parbudget  ]
  
    def index
      @parbudget_readers = Parbudget::Reader.all.page(params[:page])
    end
  
    def destroy
      begin
        @parbudget_reader = Parbudget::Reader.find(params[:id])
        if !@parbudget_reader.blank?
          if !current_user.blank? && current_user.id == @parbudget_reader.user_id
            flash[:error] = I18n.t("admin.parbudget_readers.administrator.restricted_removal")
          else
            user = User.find(@parbudget_reader.user_id)
            user.profiles_id = nil
            user.save
            @parbudget_reader.destroy
          end
        else
          flash[:error] = I18n.t("admin.parbudget_readers.administrator.restricted_removal")
        end
  
        redirect_to admin_parbudget_readers_path
      rescue
        flash[:error] = I18n.t("admin.parbudget_readers.administrator.restricted_removal")
        redirect_to admin_parbudget_readers_path
      end
    end
  end