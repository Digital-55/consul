class Admin::Parbudget::ProjectsController < Admin::Parbudget::BaseController
  respond_to :html, :js, :csv, :pdf
  before_action :load_data, only: [:index]
  before_action :load_center

  def index
    search(params)
    @projects = @projects.page(params[:page]).per(20)
  end

  def new
    @project = ::Parbudget::Project.new
  end

  def edit
  end

  def create

    xxxxx
    @project=  @model.new(project_strong_params)
    if @project.save
      redirect_to admin_parbudget_projects_path,  notice: I18n.t("admin.parbudget.project.create_success")
    else
      flash[:error] = I18n.t("admin.parbudget.project.create_error")
      render :new
    end
  # rescue
  #   flash[:error] = I18n.t("admin.parbudget.project.create_error")
  #   redirect_to admin_parbudget_projects_path
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
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @project.denomination,
        layout: 'pdf.html',
        page_size: 'A4',
        encoding: "UTF-8"
      end
    end
  end

  private 

  def get_model
    @model = ::Parbudget::Project
  end

  def project_strong_params
    params.require(:parbudget_project).permit(:denomination, :code, :year,:votes, :cost, :author, :parbudget_ambit_id,
      :email, :phone, :association, :url, :descriptive_memory, :parbudget_topic_id, :entity_association, :parbudget_ersponsible,
      :plate_proceeds, :license_plate, :plate_installed, :assumes_dgpc, :code_old)
  end

  def load_resource
    @project = @model.find(params[:id])
  rescue
    @project = nil
  end

  def load_center
    @centers = ::Parbudget::Center.all
  end

  def load_data
    @status = []
    @subnav = [{title: "Todos",value: "all"}]
    @model.pluck(:year).uniq.each do |year|
      @subnav.push({title: "Año #{year}",value: year.to_s})
    end
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
