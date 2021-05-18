class  Admin::ActuationsMultiYearsController < Admin::Sures::BaseController
    load_and_authorize_resource
    respond_to :html, :js, :json
  
    def index
    end
  
    def show
    end
  
    def new
      @actuations_multi_year = Admin::ActuationsMultiYear.new
      respond_with(@actuations_multi_year)
    end
  
    def edit
    end
  
    def create
      respond_with(@actuations_multi_year)
    end
  
    def update
      respond_with(@actuations_multi_year)
    end
  
    def destroy
      respond_with(@actuations_multi_year)
    end
  
    protected
    def actuations_multi_year_params
      params.require(:actuations_multi_year).permit(:annos, :values)
    end
  end
  