class Admin::Complan::EditorsController < Admin::BaseController
  load_and_authorize_resource :editor, class: "Complan::Editor"
  has_filters %w[users superadministrators administrators sures_administrators section_administrators 
    organizations officials moderators valuators managers consultants editors editors_parbudget readers_parbudget  ]

  def index
    @complan_editors = Complan::Editor.all.page(params[:page])
  end

  def destroy
    begin
      @complan_editor = Complan::Editor.find(params[:id])
      if !@complan_editor.blank?
        if !current_user.blank? && current_user.id == @complan_editor.user_id
          flash[:error] = I18n.t("admin.complan_editors.administrator.restricted_removal")
        else
          user = User.find(@complan_editor.user_id)
          user.profiles_id = nil
          user.save
          @complan_editor.destroy
        end
      else
        flash[:error] = I18n.t("admin.complan_editors.administrator.restricted_removal")
      end

      redirect_to admin_complan_editors_path
    rescue
      flash[:error] = I18n.t("admin.complan_editors.administrator.restricted_removal")
      redirect_to admin_complan_editors_path
    end
  end
end
