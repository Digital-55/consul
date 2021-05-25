class Admin::Parbudget::AmbitsController < Admin::Parbudget::BaseController
  respond_to :html, :js
  before_action :load_resource, only: [:update_ambit,:destroy]

  def index
   @ambits = @model.all.page(params[:page]).per(20)
  end

  def create_ambit
    ambit=  @model.new
    if ambit.save(validate: false)
      redirect_to admin_parbudget_ambits_path,  notice: I18n.t("admin.sg.form.notice_select_destroy")
    else
      flash[:error] = I18n.t("admin.sg.form.error_select_destroy")
      redirect_to admin_parbudget_ambits_path(errors: ambit.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.sg.form.error_select_destroy")
    redirect_to admin_parbudget_ambits_path
  end

  def update_ambit
    if @ambit.update(ambit_strong_params)
      redirect_to admin_parbudget_ambits_path,  notice: I18n.t("admin.sg.form.notice_select_destroy")
    else
      flash[:error] = I18n.t("admin.sg.form.error_select_destroy")
      redirect_to admin_parbudget_ambits_path(errors: @ambit.errors.full_messages)
    end
  # rescue
  #   flash[:error] = I18n.t("admin.sg.form.error_select_destroy")
  #   redirect_to admin_parbudget_ambits_path    
  end

  def destroy
    if @ambit.destroy
      redirect_to admin_parbudget_ambits_path,  notice: I18n.t("admin.sg.form.notice_select_destroy")
    else
      flash[:error] = I18n.t("admin.sg.form.error_select_destroy")
      redirect_to admin_parbudget_ambits_path(errors: @ambit.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.sg.form.error_select_destroy")
    redirect_to admin_parbudget_ambits_path
  end

  private 

  def get_model
    @model = ::Parbudget::Ambit
  end

  def ambit_strong_params
    params.require(:parbudget_ambit).permit(:name, :code)
  end

  def load_resource
    @ambit =  @model.find(params[:id])
  rescue
    @ambit = nil
  end
end
