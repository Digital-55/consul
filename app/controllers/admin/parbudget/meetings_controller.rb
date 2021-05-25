class Admin::Parbudget::MeetingsController < Admin::Parbudget::BaseController
  respond_to :html, :js

  def index
    @meetings = ::Parbudget::Meeting.all.page(params[:page]).per(20)
  end

  def create
    
  end

  def update
    
  end

  def destroy
    
  end

  def show
    
  end

  private 

  def get_model
    @model = ::Parbudget::Meeting
  end

  def meeting_strong_params
    params.require(:meeting).permit(:name, :code)
  end

  def load_resource
    @ambit = ::Parbudget::Meeting.find(params[:id])
  rescue
    @ambit = nil
  end
end
