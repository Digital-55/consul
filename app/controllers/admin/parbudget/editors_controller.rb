class Admin::Parbudget::EditorsController < Admin::BaseController
  load_and_authorize_resource :editor, class: "Parbudget::Editor"
  has_filters %w[users superadministrators administrators sures_administrators section_administrators 
    organizations officials moderators valuators managers consultants editors editors_parbudget readers_parbudget  ]
  
  def index
    @parbudget_editors = Parbudget::Editor.all.page(params[:page])
  end

  def destroy
    begin
      @parbudget_editor = Parbudget::Editor.find(params[:id])
      if !@parbudget_editor.blank?
        if !current_user.blank? && current_user.id == @parbudget_editor.user_id
          flash[:error] = I18n.t("admin.parbudget_editors.administrator.restricted_removal")
        else
          user = User.find(@parbudget_editor.user_id)
          user.profiles_id = nil
          user.save
          @parbudget_editor.destroy
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
end