class Admin::Complan::BaseController < Admin::BaseController
  helper_method :namespace

  before_action :load_maintance
  before_action :get_model
  before_action :load_resource, only: [:edit,:update,:show,:destroy]
  skip_before_action :verify_authenticity_token

  private

    def namespace
      "admin"
    end

    def load_maintance
      @maintance_array = ["performances","centers","strategies","financings","thecnical_tables","projects","typologies"]
    end

end
