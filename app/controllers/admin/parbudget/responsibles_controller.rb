class Admin::Parbudget::ResponsiblesController < Admin::Parbudget::BaseController
  respond_to :html, :js

  def index
    @responsibles = ::Parbudget::Responsible.all.page(params[:page]).per(20)
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
    @model = ::Parbudget::Responsible
  end

  def responsible_strong_params
    params.require(:responsible).permit(:name, :code)
  end

  def load_resource
    @ambit = ::Parbudget::Responsible.find(params[:id])
  rescue
    @ambit = nil
  end
end
