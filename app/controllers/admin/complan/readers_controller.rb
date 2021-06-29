class Admin::Complan::ReadersController < Admin::BaseController
  load_and_authorize_resource
  has_filters %w[users superadministrators administrators sures_administrators section_administrators 
    organizations officials moderators valuators managers consultants editors editors_parbudget readers_parbudget editors_complan readers_complan]

  def index
    @complan_readers = Complan::Reader.all
  end

  
end
