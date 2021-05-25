class Admin::Parbudget::ProjectsController < Admin::Parbudget::BaseController
  respond_to :html, :js

  def index
    @projects = ::Parbudget::Project.all.page(params[:page]).per(20)
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
    @model = ::Parbudget::Project
  end

  def project_strong_params
    params.require(:project).permit(:name, :code)
  end

  def load_resource
    @ambit = ::Parbudget::Project.find(params[:id])
  rescue
    @ambit = nil
  end
end
