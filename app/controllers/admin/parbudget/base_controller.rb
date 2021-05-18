class Admin::Parbudget::BaseController < Admin::BaseController
  helper_method :namespace

  before_action :load_maintance

  private

    def namespace
      "admin"
    end

    def load_maintance
      @maintance_array = ["ambits","centers","projects","responsibles","meetings","topics"]
    end

end
