class Admin::Parbudget::AmbitsController < Admin::Parbudget::BaseController
  respond_to :html, :js, :csv
  before_action :load_resource, only: [:update_ambit,:destroy]

  load_and_authorize_resource :ambit, class: "Parbudget::Ambit"

  def index
    search(params)
    @ambits = Kaminari.paginate_array(@ambits).page(params[:page]).per(20)
  end

  def create_ambit
    ambit=  @model.new
    if ambit.save(validate: false)
      redirect_to admin_parbudget_ambits_path,  notice: I18n.t("admin.parbudget.ambit.create_success")
    else
      flash[:error] = I18n.t("admin.parbudget.ambit.create_error")
      redirect_to admin_parbudget_ambits_path(errors: ambit.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.ambit.create_error")
    redirect_to admin_parbudget_ambits_path
  end

  def update_ambit
    if @ambit.update(ambit_strong_params)
      redirect_to admin_parbudget_ambits_path,  notice: I18n.t("admin.parbudget.ambit.update_success")
    else
      flash[:error] = I18n.t("admin.parbudget.ambit.update_error")
      redirect_to admin_parbudget_ambits_path(errors: @ambit.errors.full_messages, id: @ambit.id)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.ambit.update_error")
    redirect_to admin_parbudget_ambits_path    
  end

  def destroy
    if @ambit.destroy
      redirect_to admin_parbudget_ambits_path,  notice: I18n.t("admin.parbudget.ambit.destroy_success")
    else
      flash[:error] =  I18n.t("admin.parbudget.ambit.destroy_error")
      redirect_to admin_parbudget_ambits_path(errors: @ambit.errors.full_messages, id: @ambit.id)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.ambit.destroy_error")
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

  def search(parametrize = {})
    @ambits = @model.all
    @filters = []

    begin
      if !parametrize[:search_code].blank?
        @filters.push("#{I18n.t('admin.parbudget.ambit.search_code')}: #{parametrize[:search_code]}")
        @ambits = @ambits.where("translate(UPPER(cast(code as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_code]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:search_ambit].blank?
        @filters.push("#{I18n.t('admin.parbudget.ambit.search_ambit')}: #{parametrize[:search_ambit]}")
        @ambits = @ambits.where("translate(UPPER(cast(name as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_ambit]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
      end
    rescue
    end

    begin
      if !parametrize[:sort_by].blank?
        if parametrize[:direction].blank? || parametrize[:direction].to_s == "asc"
          @ambits = @ambits.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }
        else
          @ambits = @ambits.sort_by { |a| a.try(parametrize[:sort_by].to_sym) }.reverse
        end
      else
        @ambits = @ambits.sort_by { |a| a.try(@model.get_columns[0].to_sym) }
      end
    rescue
    end
  rescue
    @ambits = []
    @filters = []
   end
end
