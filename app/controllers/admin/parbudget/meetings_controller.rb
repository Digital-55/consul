class Admin::Parbudget::MeetingsController < Admin::Parbudget::BaseController
  respond_to :html, :js, :csv, :pdf
  before_action :load_data, only: [:index]

  def index
    search(params)
    @meetings = @meetings.page(params[:page]).per(20)
  end

  def new
    @meeting = @model.new
  end

  def edit
  end

  def create
    @meeting=  @model.new(meeting_strong_params)
    if @meeting.save
      redirect_to admin_parbudget_meetings_path,  notice: I18n.t("admin.parbudget.meeting.create_success")
    else
      flash[:error] = I18n.t("admin.parbudget.meeting.create_error")
      render :new
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.meeting.create_error")
    redirect_to admin_parbudget_meetings_path
  end

  def update
    if @meeting.update(meeting_strong_params)
      redirect_to admin_parbudget_meetings_path,  notice: I18n.t("admin.parbudget.meeting.update_success")
    else
      flash[:error] = I18n.t("admin.parbudget.meeting.update_error")
      render :edit
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.meeting.update_error")
    redirect_to admin_parbudget_meetings_path    
  end

  def destroy
    if @meeting.destroy
      redirect_to admin_parbudget_meetings_path,  notice: I18n.t("admin.parbudget.meeting.destroy_success")
    else
      flash[:error] = I18n.t("admin.parbudget.meeting.destroy_error")
      redirect_to admin_parbudget_meetings_path(errors: @meeting.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.meeting.destroy_error")
    redirect_to admin_parbudget_meetings_path
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        
        render pdf: "#{@meeting.who_requests}_#{@meeting.date_at_convert}",
        layout: 'pdf.html',
        page_size: 'A4',
        encoding: "UTF-8"
       
      end
    end
  end

  private 

  def get_model
    @model = ::Parbudget::Meeting
  end

  def load_data
    @subnav = [{title: "Todos",value: "all"}]
  end

  def meeting_strong_params
    params.require(:parbudget_meeting).permit(:reason, :date_at, :who_requests, {parbudget_assistants_attributes: [:id, :full_name, :_destroy]})
  end

  def load_resource
    @meeting = @model.find(params[:id])
  rescue
    @meeting = nil
  end

  def search(parametrize = {})
    @meetings = @model.all
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
