class Legislation::ProposalsController < Legislation::BaseController
  include CommentableActions
  include FlagActions
  include ImageAttributes

  before_action :parse_tag_filter, only: :index
  before_action :load_categories, only: [:index, :new, :create, :edit, :map, :summary]
  before_action :load_proccess_categories, only: [:new, :create, :edit, :update]
  before_action :load_geozones, only: [:edit, :map, :summary]
  before_action :destroy_map_location_association, only: :update

  before_action :authenticate_user!, except: [:index, :show, :map, :summary]
  before_action :validate_process, only: [:new,:edit,:create,:update]
  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :proposal, class: "Legislation::Proposal", through: :process

  invisible_captcha only: [:create, :update], honeypot: :subtitle

  has_orders %w{confidence_score created_at}, only: :index
  has_orders %w{most_voted newest oldest}, only: :show

  helper_method :resource_model, :resource_name
  respond_to :html, :js

  def show
    super
    @categories_s = ""
    @proposal.categories.each do |p|
      if @categories_s.blank?
        @categories_s = p.name
      else
        @categories_s = @categories_s + ", " + p.name
      end
    end
    legislation_proposal_votes(@process.proposals)
    @document = Document.new(documentable: @proposal)
    if request.path != legislation_process_proposal_path(params[:process_id], @proposal)
      redirect_to legislation_process_proposal_path(params[:process_id], @proposal),
                  status: :moved_permanently
    end
  end

  def create
    @proposal = Legislation::Proposal.new(proposal_params.merge(author: current_user))
    if @proposal.save
      redirect_to legislation_process_proposal_path(params[:process_id], @proposal), notice: I18n.t("flash.actions.create.proposal")
    else
      render :new
    end
  end

  def update    
    if @proposal.update(proposal_params.merge(author: current_user))
      redirect_to legislation_process_proposal_path(params[:process_id], @proposal), notice: I18n.t("flash.actions.update.proposal")
    else
      render :edit
    end
  end


  def index_customization
    load_successful_proposals
    load_featured unless @proposal_successful_exists
    hide_advanced_search if custom_search?
  end

  def vote
    @proposal.register_vote(current_user, params[:value])
    legislation_proposal_votes(@proposal)
  end

  private

    def proposal_params
      params.require(:legislation_proposal).permit(:legislation_process_id, :title,
                    :summary, :description,  :video_url, :tag_list,
                    :terms_of_service, :geozone_id, :skip_map, :proposal_type, :type_other_proposal,
                    image_attributes: image_attributes,
                    documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id],
                    other_proposal_attributes: [:type_other_proposal, :name, :address, :phone, :agent, :agent_title, :citizen_entities,
                      :cif, :entity_type, :justify_text_declaration_1, :justify_text_declaration_2
                                         
                    ],
                    category_ids: [],
                    map_location_attributes: [:latitude, :longitude, :zoom])
    end

    def validate_process
      process = Legislation::Process.find_by(id: params[:process_id])
      if !process.blank? && process.film_library && params[:other].blank?
        proposals = Legislation::Proposal.where(process: process).where(type_other_proposal: nil)
        if !(process.proposals_phase.open? && !current_user.blank? && (!process.film_library? || process.film_library? && (process.film_library_limit.blank? || process.film_library_limit == 0 || process.film_library_limit.to_i > proposals.count) && (!process.film_library_admin || process.film_library_admin && current_user.administrator?)))
          redirect_to legislation_process_path(params[:process_id]), alert: "El proceso tiene bloqueada la gestión de la propuesta"
        end
      end
    end

    def resource_model
      Legislation::Proposal
    end

    def resource_name
      "proposal"
    end

    def load_successful_proposals
      @proposal_successful_exists = Legislation::Proposal.successful.exists?
    end


    def load_proccess_categories
      @categories = Legislation::Category.where(legislation_process_id: params[:process_id])
    end

    def custom_search?
      params[:custom_search].present?
    end

    def destroy_map_location_association
      return if params[:proposal].blank?
      map_location = params[:proposal][:map_location_attributes]
      if map_location && (map_location[:longitude] && map_location[:latitude]).blank? && !map_location[:id].blank?
        MapLocation.destroy(map_location[:id])
      end
    end

end
