class CscController < ApplicationController
    skip_authorization_check
  
    layout "devise", only: [:welcome, :verification]
  
    def index
    end

    def members
    end
  
  end
  