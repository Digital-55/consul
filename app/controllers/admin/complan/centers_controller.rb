class Admin::Complan::CentersController < Admin::Complan::BaseController
  respond_to :html, :js, :csv, :pdf
  before_action :load_data, only: [:index]

  def index
    search(params)
    @centers = Kaminari.paginate_array(@centers).page(params[:page]).per(20)
  end

  def new
    @center = @model.new
  end

  def edit
  end

  def create
    @center=  @model.new(center_strong_params)
    if @center.save
      redirect_to admin_complan_centers_path,  notice: I18n.t("admin.complan.center.create_success")
    else
      flash[:error] = I18n.t("admin.complan.center.create_error")
      render :new
    end
  rescue
    flash[:error] = I18n.t("admin.complan.center.create_error")
    redirect_to admin_complan_centers_path
  end

  def update
    if @center.update(center_strong_params)
      redirect_to admin_complan_centers_path,  notice: I18n.t("admin.complan.center.update_success")
    else
      flash[:error] = I18n.t("admin.complan.center.update_error")
      render :edit
    end
  rescue
    flash[:error] = I18n.t("admin.complan.center.update_error")
    redirect_to admin_complan_centers_path    
  end

  def destroy
    if @center.destroy
      redirect_to admin_complan_centers_path,  notice: I18n.t("admin.complan.center.destroy_success")
    else
      flash[:error] = I18n.t("admin.complan.center.destroy_error")
      redirect_to admin_complan_centers_path(errors: @center.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.complan.center.destroy_error")
    redirect_to admin_complan_centers_path
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @center.denomination,
        layout: 'pdf.html',
        page_size: 'A4',
        encoding: "UTF-8"
      end
    end
  end

  private 

  def get_model
    @model = ::Complan::Center
  end

  def center_strong_params
    params.require(:complan_center).permit(:denomination, :organism, :address,:dg,:sg,
      :complan_people_attributes=> [:id, :name, :position, :phone, :email, :address,:_destroy])
  end

  def load_resource
    @center = @model.find(params[:id])
  rescue
    @center = nil
  end

  def load_data
  end

  def search(parametrize = {})
    @centers = @model.all
    @filters = []

    begin
      if !parametrize[:search_identificator].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_identificator')}: #{parametrize[:search_identificator]}")
        @centers = @centers.where("translate(UPPER(cast(code as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_identificator]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_title].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_title')}: #{parametrize[:search_title]}")
        @centers = @centers.where("translate(UPPER(cast(web_title as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_title]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
          translate(UPPER(cast(denomination as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_title]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_memory].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_memory')}: #{parametrize[:search_memory]}")
        @centers = @centers.where("translate(UPPER(cast(descriptive_memory as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_memory]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_status].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_status')}: #{parametrize[:search_status]}")
        @centers = @centers.where("translate(UPPER(cast(status as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_status]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_center].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_center')}: #{parametrize[:search_center]}")
        @centers = @centers.where("id in (?)", ::Parbudget::Center.where("translate(UPPER(cast(denomination as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_center]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')").select(:complan_center_id))
      end
    rescue
    end

    begin
      if !parametrize[:search_year_to].blank? && !parametrize[:search_year_end].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_year_to')}: #{parametrize[:search_year_to]}")
        @filters.push("#{I18n.t('admin.complan.center.search_year_end')}: #{parametrize[:search_year_end]}")
        @centers = @centers.where("year BETWEEN ? AND ?", parametrize[:search_year_to], parametrize[:search_year_end])
      elsif !parametrize[:search_year_to].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_year_to')}: #{parametrize[:search_year_to]}")
        @centers = @centers.where("date_at >= ?", parametrize[:search_year_to])
      elsif !parametrize[:search_year_end].blank?
        @filters.push("#{I18n.t('admin.complan.center.search_year_end')}: #{parametrize[:search_year_end]}")
        @centers = @centers.where("date_at <= ?", parametrize[:search_year_end])
      end
    rescue
    end

    begin
      if !parametrize[:sort_by].blank?
        if parametrize[:direction].blank? || parametrize[:direction].to_s == "asc"
          @centers = @centers.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }
        else
          @centers = @centers.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }.reverse
        end
      else
        @centers = @centers.sort_by { |a| a.try(@model.get_columns[0].to_sym) }
      end
    rescue
    end
  rescue
    @centers = []
    @filters = []
  end
end
