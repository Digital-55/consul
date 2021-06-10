class Admin::Parbudget::CentersController < Admin::Parbudget::BaseController
  respond_to :html, :js, :csv, :pdf
  before_action :load_data, only: [:index]

  def index
    search(params)
    @centers = @centers.page(params[:page]).per(20)
  end

  def new
    @center = @model.new
  end

  def edit
  end

  def create
    @center=  @model.new(center_strong_params)
    if @center.save
      redirect_to admin_parbudget_centers_path,  notice: I18n.t("admin.parbudget.center.create_success")
    else
      flash[:error] = I18n.t("admin.parbudget.center.create_error")
      render :new
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.center.create_error")
    redirect_to admin_parbudget_centers_path
  end

  def update
    if @center.update(center_strong_params)
      redirect_to admin_parbudget_centers_path,  notice: I18n.t("admin.parbudget.center.update_success")
    else
      flash[:error] = I18n.t("admin.parbudget.center.update_error")
      render :edit
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.center.update_error")
    redirect_to admin_parbudget_centers_path    
  end

  def destroy
    if @center.destroy
      redirect_to admin_parbudget_centers_path,  notice: I18n.t("admin.parbudget.center.destroy_success")
    else
      flash[:error] = I18n.t("admin.parbudget.center.destroy_error")
      redirect_to admin_parbudget_centers_path(errors: @center.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.center.destroy_error")
    redirect_to admin_parbudget_centers_path
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
    @model = ::Parbudget::Center
  end

  def center_strong_params
    params.require(:parbudget_center).permit(:denomination, :code, :code_section, :code_program, :responsible,
      :government_area, :general_direction, :parbudget_project_id,
      {:parbudget_responsibles_attributes => [:parbudget_center_id, :full_name, :email, :phone, :position, :_destroy]})
  end


  def load_resource
    @center = @model.find(params[:id])
  rescue
    @center = nil
  end

  def load_data
    @responsibles = ::Parbudget::Responsible.all
    @projects = ::Parbudget::Project.all
  end

  def search(parametrize = {})
    @centers = @model.all
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
