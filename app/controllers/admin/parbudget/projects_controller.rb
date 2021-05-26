class Admin::Parbudget::ProjectsController < Admin::Parbudget::BaseController
  respond_to :html, :js, :csv

  def index
    search(params)
    @projects = @projects.page(params[:page]).per(20)
  end

  def new
    @project = @model.new
  end

  def edit
  end

  def create
    @project=  @model.new(project_strong_params)
    if @project.save
      redirect_to admin_parbudget_projects_path,  notice: I18n.t("admin.parbudget.project.create_success")
    else
      flash[:error] = I18n.t("admin.parbudget.project.create_error")
      render :new
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.project.create_error")
    redirect_to admin_parbudget_projects_path
  end

  def update
    if @project.update(project_strong_params)
      redirect_to admin_parbudget_projects_path,  notice: I18n.t("admin.parbudget.project.update_success")
    else
      flash[:error] = I18n.t("admin.parbudget.project.update_error")
      render :edit
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.project.update_error")
    redirect_to admin_parbudget_projects_path    
  end

  def destroy
    if @project.destroy
      redirect_to admin_parbudget_projects_path,  notice: I18n.t("admin.parbudget.project.destroy_success")
    else
      flash[:error] = I18n.t("admin.parbudget.project.destroy_error")
      redirect_to admin_parbudget_projects_path(errors: @project.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.project.destroy_error")
    redirect_to admin_parbudget_projects_path
  end

  def show
  end

  private 

  def get_model
    @model = ::Parbudget::Project
  end

  def project_strong_params
    params.require(:project).permit(:name, :code)
  end

  def load_resource
    @project = @model.find(params[:id])
  rescue
    @project = nil
  end

  def search(parametrize = {})
    @projects = @model.all
    @filters = []

    if !parametrize[:search_code].blank?
      @filters.push("#{I18n.t('admin.parbudget.ambit.search_code')}: #{parametrize[:search_code]}")
      @ambits = @ambits.where("translate(UPPER(cast(code as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_code]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
    end

    if !parametrize[:search_ambit].blank?
      @filters.push("#{I18n.t('admin.parbudget.ambit.search_ambit')}: #{parametrize[:search_ambit]}")
      @ambits = @ambits.where("translate(UPPER(cast(name as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_ambit]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
    end
  end
end
