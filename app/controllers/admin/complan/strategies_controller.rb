class Admin::Complan::StrategiesController < Admin::Complan::BaseController
  respond_to :html, :js, :csv, :pdf
  before_action :load_data, only: [:index]
  before_action :load_strategy

  def index
    search(params)
    @strategies = Kaminari.paginate_array(@strategies).page(params[:page]).per(20)
  end

  def new
    @strategy = ::Parbudget::Strategy.new
  end

  def edit
  end

  def create
    @strategy=  @model.new(strategy_strong_params)
    if @strategy.save
      redirect_to admin_complan_strategies_path,  notice: I18n.t("admin.complan.strategy.create_success")
    else
      flash[:error] = I18n.t("admin.complan.strategy.create_error")
      render :new
    end
  rescue
    flash[:error] = I18n.t("admin.complan.strategy.create_error")
    redirect_to admin_complan_strategies_path
  end

  def update
    if @strategy.update(strategy_strong_params)
      if strategy_strong_params[:complan_strategy_ids].blank?
        @strategy.complan_strategies.each do |strategy|
          strategy.complan_strategy_id = nil
          strategy.save(validate: false)
        end
        @strategy.complan_strategies = []
        @strategy.save
      end
      redirect_to admin_complan_strategies_path,  notice: I18n.t("admin.complan.strategy.update_success")
    else
      flash[:error] = I18n.t("admin.complan.strategy.update_error")
      render :edit
    end
  rescue
    flash[:error] = I18n.t("admin.complan.strategy.update_error")
    redirect_to admin_complan_strategies_path    
  end

  def destroy
    @strategy.complan_strategies.each do |strategy|
      strategy.complan_strategy_id = nil
      strategy.save(validate: false)
    end
    @strategy.complan_strategies = []
    @strategy.save
    if @strategy.destroy
      redirect_to admin_complan_strategies_path,  notice: I18n.t("admin.complan.strategy.destroy_success")
    else
      flash[:error] = I18n.t("admin.complan.strategy.destroy_error")
      redirect_to admin_complan_strategies_path(errors: @strategy.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.complan.strategy.destroy_error")
    redirect_to admin_complan_strategies_path
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @strategy.denomination,
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

  def strategy_strong_params
    params.require(:complan_strategy).permit(:denomination, :code, :year,:web_title,:votes, :cost, :author, :complan_ambit_id,
      :email, :phone, :url, :descriptive_memory, :complan_topic_id, :entity, :complan_responsible_id, :status,
      :plate_proceeds, :license_plate, :plate_installed, :code_old, :complan_strategy_ids => [],
      :complan_economic_budgets_attributes=> [:id, :year, :import, :start_date, :end_date, :count_managing_body, :count_functional,
        :economic,:element_pep,:financing,:type_contract,:_destroy], :complan_medias_attributes => [:id, :title, :text_document, 
        :attachment,  :_destroy], :complan_links_attributes => [:id,:url, :_destroy])
  end

  def load_resource
    @strategy = @model.find(params[:id])
  rescue
    @strategy = nil
  end

  def load_strategy
    @strategies = ::Parbudget::Strategy.all
    @ambits = ::Parbudget::Ambit.all.select(:id, :name, :code)
    @topics = ::Parbudget::Topic.all.select(:id,:name)
    @responsibles = ::Parbudget::Responsible.all.select(:id, :full_name)
    @status = [
      [I18n.t('admin.complan.strategy.status.definition'),I18n.t('admin.complan.strategy.status.definition')],
      [I18n.t('admin.complan.strategy.status.contract'),I18n.t('admin.complan.strategy.status.contract')],
      [I18n.t('admin.complan.strategy.status.exec'),I18n.t('admin.complan.strategy.status.exec')],
      [I18n.t('admin.complan.strategy.status.finished'),I18n.t('admin.complan.strategy.status.finished')],
      [I18n.t('admin.complan.strategy.status.invalid'),I18n.t('admin.complan.strategy.status.invalid')]
    ]
  end

  def load_data
    @status = []
    @subnav = [{title: "Todos",value: "all"}]
    @model.pluck(:year).uniq.each do |year|
      @subnav.push({title: "Año #{year}",value: year.to_s})
    end
  end

  def search(parametrize = {})
    @strategies = @model.all
    @filters = []

    begin
      if !params[:subnav].blank? && params[:subnav].to_s != "all"
        @strategies = @strategies.where(year: params[:subnav])
      end
    rescue
    end

    begin
      if !parametrize[:search_identificator].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_identificator')}: #{parametrize[:search_identificator]}")
        @strategies = @strategies.where("translate(UPPER(cast(code as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_identificator]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_title].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_title')}: #{parametrize[:search_title]}")
        @strategies = @strategies.where("translate(UPPER(cast(web_title as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_title]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
          translate(UPPER(cast(denomination as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_title]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_memory].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_memory')}: #{parametrize[:search_memory]}")
        @strategies = @strategies.where("translate(UPPER(cast(descriptive_memory as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_memory]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_status].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_status')}: #{parametrize[:search_status]}")
        @strategies = @strategies.where("translate(UPPER(cast(status as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_status]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_strategy].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_strategy')}: #{parametrize[:search_strategy]}")
        @strategies = @strategies.where("id in (?)", ::Parbudget::Strategy.where("translate(UPPER(cast(denomination as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_strategy]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')").select(:complan_strategy_id))
      end
    rescue
    end

    begin
      if !parametrize[:search_year_to].blank? && !parametrize[:search_year_end].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_year_to')}: #{parametrize[:search_year_to]}")
        @filters.push("#{I18n.t('admin.complan.strategy.search_year_end')}: #{parametrize[:search_year_end]}")
        @strategies = @strategies.where("year BETWEEN ? AND ?", parametrize[:search_year_to], parametrize[:search_year_end])
      elsif !parametrize[:search_year_to].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_year_to')}: #{parametrize[:search_year_to]}")
        @strategies = @strategies.where("date_at >= ?", parametrize[:search_year_to])
      elsif !parametrize[:search_year_end].blank?
        @filters.push("#{I18n.t('admin.complan.strategy.search_year_end')}: #{parametrize[:search_year_end]}")
        @strategies = @strategies.where("date_at <= ?", parametrize[:search_year_end])
      end
    rescue
    end

    begin
      if !parametrize[:sort_by].blank?
        if parametrize[:direction].blank? || parametrize[:direction].to_s == "asc"
          @strategies = @strategies.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }
        else
          @strategies = @strategies.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }.reverse
        end
      else
        @strategies = @strategies.sort_by { |a| a.try(@model.get_columns[0].to_sym) }
      end
    rescue
    end
  rescue
    @strategies = []
    @filters = []
  end
end
