class Admin::ProfilesController < Admin::BaseController
    load_and_authorize_resource
    has_filters %w[usuarios superadministrator administrator]

    def index
    end
end