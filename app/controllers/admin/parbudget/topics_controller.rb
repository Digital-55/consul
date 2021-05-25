class Admin::Parbudget::TopicsController < Admin::Parbudget::BaseController
  respond_to :html, :js

  def index
    @topics = ::Parbudget::Topic.all.page(params[:page]).per(20)
  end

  def create
    
  end

  def update
    
  end

  def destroy
    
  end

  private 

  def get_model
    @model = ::Parbudget::Topic
  end

  def topic_strong_params
    params.require(:topic).permit(:name, :code)
  end

  def load_resource
    @ambit = ::Parbudget::Topic.find(params[:id])
  rescue
    @ambit = nil
  end
end
