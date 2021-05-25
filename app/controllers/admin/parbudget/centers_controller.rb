class Admin::Parbudget::CentersController < Admin::Parbudget::BaseController
  respond_to :html, :js

  def index
    @centers = ::Parbudget::Center.all.page(params[:page]).per(20)
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
    @model = ::Parbudget::Center
  end

  def center_strong_params
    params.require(:center).permit(:name, :code)
  end

  def load_resource
    @ambit = ::Parbudget::Center.find(params[:id])
  rescue
    @ambit = nil
  end
end
