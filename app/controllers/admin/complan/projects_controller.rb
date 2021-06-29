class Admin::Complan::ProjectsController < Admin::Complan::BaseController
  respond_to :html, :js, :csv, :pdf
  before_action :load_data, only: [:index]
  before_action :load_financing
  before_action :authenticate_editor, only: [:new, :create, :edit, :update, :destroy]

  def index
    search(params)
    @projects = Kaminari.paginate_array(@projects).page(params[:page]).per(20)
  end

  def create_project
    @project=  @model.new(project_strong_params)
    if @project.save
      redirect_to admin_complan_projects_path,  notice: I18n.t("admin.complan.project.create_success")
    else
      flash[:error] = I18n.t("admin.complan.project.create_error")
      render :new
    end
  rescue
    flash[:error] = I18n.t("admin.complan.project.create_error")
    redirect_to admin_complan_projects_path
  end

  def update_project
    if @project.update(project_strong_params)
      redirect_to admin_complan_projects_path,  notice: I18n.t("admin.complan.project.update_success")
    else
      flash[:error] = I18n.t("admin.complan.project.update_error")
      render :edit
    end
  rescue
    flash[:error] = I18n.t("admin.complan.project.update_error")
    redirect_to admin_complan_projects_path    
  end

  def destroy
    if @project.destroy
      redirect_to admin_complan_projects_path,  notice: I18n.t("admin.complan.project.destroy_success")
    else
      flash[:error] = I18n.t("admin.complan.project.destroy_error")
      redirect_to admin_complan_projects_path(errors: @project.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.complan.project.destroy_error")
    redirect_to admin_complan_projects_path
  end

  private 

  def get_model
    @model = ::Complan::Project
  end

  def project_strong_params
    params.require(:complan_project).permit(:denomination, :code, :year,:web_title,:votes, :cost, :author, :complan_ambit_id,
      :email, :phone, :url, :descriptive_memory, :complan_topic_id, :entity, :complan_responsible_id, :status,
      :plate_proceeds, :license_plate, :plate_installed, :code_old, :complan_project_ids => [],
      :complan_economic_budgets_attributes=> [:id, :year, :import, :start_date, :end_date, :count_managing_body, :count_functional,
        :economic,:element_pep,:project,:type_contract,:_destroy], :complan_medias_attributes => [:id, :title, :text_document, 
        :attachment,  :_destroy], :complan_links_attributes => [:id,:url, :_destroy])
  end

  def load_resource
    @project = @model.find(params[:id])
  rescue
    @project = nil
  end

  def load_project
    @projects = ::Parbudget::Financing.all
    @ambits = ::Parbudget::Ambit.all.select(:id, :name, :code)
    @topics = ::Parbudget::Topic.all.select(:id,:name)
    @responsibles = ::Parbudget::Responsible.all.select(:id, :full_name)
    @status = [
      [I18n.t('admin.complan.project.status.definition'),I18n.t('admin.complan.project.status.definition')],
      [I18n.t('admin.complan.project.status.contract'),I18n.t('admin.complan.project.status.contract')],
      [I18n.t('admin.complan.project.status.exec'),I18n.t('admin.complan.project.status.exec')],
      [I18n.t('admin.complan.project.status.finished'),I18n.t('admin.complan.project.status.finished')],
      [I18n.t('admin.complan.project.status.invalid'),I18n.t('admin.complan.project.status.invalid')]
    ]
  end

  def load_data
    @status = []
    @subnav = [{title: "Todos",value: "all"}]
    # @model.pluck(:year).uniq.each do |year|
    #   @subnav.push({title: "Año #{year}",value: year.to_s})
    # end
  end

  def search(parametrize = {})
    @projects = @model.all
    @filters = []

    begin
      if !params[:subnav].blank? && params[:subnav].to_s != "all"
        @projects = @projects.where(year: params[:subnav])
      end
    rescue
    end

    begin
      if !parametrize[:search_identificator].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_identificator')}: #{parametrize[:search_identificator]}")
        @projects = @projects.where("translate(UPPER(cast(code as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_identificator]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_title].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_title')}: #{parametrize[:search_title]}")
        @projects = @projects.where("translate(UPPER(cast(web_title as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_title]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
          translate(UPPER(cast(denomination as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_title]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_memory].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_memory')}: #{parametrize[:search_memory]}")
        @projects = @projects.where("translate(UPPER(cast(descriptive_memory as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_memory]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_status].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_status')}: #{parametrize[:search_status]}")
        @projects = @projects.where("translate(UPPER(cast(status as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_status]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_project].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_project')}: #{parametrize[:search_project]}")
        @projects = @projects.where("id in (?)", ::Parbudget::Financing.where("translate(UPPER(cast(denomination as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_project]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')").select(:complan_project_id))
      end
    rescue
    end

    begin
      if !parametrize[:search_year_to].blank? && !parametrize[:search_year_end].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_year_to')}: #{parametrize[:search_year_to]}")
        @filters.push("#{I18n.t('admin.complan.project.search_year_end')}: #{parametrize[:search_year_end]}")
        @projects = @projects.where("year BETWEEN ? AND ?", parametrize[:search_year_to], parametrize[:search_year_end])
      elsif !parametrize[:search_year_to].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_year_to')}: #{parametrize[:search_year_to]}")
        @projects = @projects.where("date_at >= ?", parametrize[:search_year_to])
      elsif !parametrize[:search_year_end].blank?
        @filters.push("#{I18n.t('admin.complan.project.search_year_end')}: #{parametrize[:search_year_end]}")
        @projects = @projects.where("date_at <= ?", parametrize[:search_year_end])
      end
    rescue
    end

    begin
      if !parametrize[:sort_by].blank?
        if parametrize[:direction].blank? || parametrize[:direction].to_s == "asc"
          @projects = @projects.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }
        else
          @projects = @projects.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }.reverse
        end
      else
        @projects = @projects.sort_by { |a| a.try(@model.get_columns[0].to_sym) }
      end
    rescue
    end
  rescue
    @projects = []
    @filters = []
  end
end
