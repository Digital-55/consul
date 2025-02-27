class ProposalsController < ApplicationController
  include FeatureFlags
  include CommentableActions
  include FlagActions
  include ImageAttributes

  before_action :parse_tag_filter, only: :index
  before_action :load_categories, only: [:index, :new, :create, :edit, :map, :summary, :borought]
  before_action :load_geozones, only: [:edit, :map, :borought, :summary]
  before_action :login_user_with_newsletter_token!, only: :newsletter_vote
  before_action :authenticate_user!, except: [:index, :show, :map, :summary, :borought]
  before_action :destroy_map_location_association, only: :update
  before_action :set_view, only: :index
  before_action :proposals_recommendations, only: :index, if: :current_user

  feature_flag :proposals

  invisible_captcha only: [:create, :update], honeypot: :subtitle

  has_orders ->(c) { Proposal.proposals_orders(c.current_user) }, only: :index
  has_orders %w[most_voted newest oldest], only: :show

  load_and_authorize_resource
  helper_method :resource_model, :resource_name
  respond_to :html, :js

  def show
    super
    @notifications = @proposal.notifications.not_moderated
    load_rank
    @document = Document.new(documentable: @proposal)
    @related_contents = Kaminari.paginate_array(@proposal.relationed_contents)
                                .page(params[:page]).per(5)

    if request.path != proposal_path(@proposal)
      redirect_to proposal_path(@proposal), status: :moved_permanently
    end
  end

  def create
    @proposal = Proposal.new(proposal_params.merge(author: current_user))
    
    if @proposal.save
      log_event("proposal", "create")
      redirect_to created_proposal_path(@proposal), notice: I18n.t("flash.actions.create.proposal")
    else
      render :new
    end
  end

  def created
  end

  def index_customization
    hide_proceedings
    discard_draft
    discard_archived
    load_retired
    load_selected
    hide_advanced_search if custom_search?
    load_featured
    remove_archived_from_order_links
  end

  def vote
    @proposal.register_vote(current_user, "yes")
    set_proposal_votes(@proposal)
    load_rank
    log_event("proposal", "support", @proposal.id, @proposal_rank, 6, @proposal_rank)
  end

  def newsletter_vote
    @proposal.register_vote(current_user, "yes")

    sign_out(:user) unless @signed_in_before_voting
    redirect_to @proposal, notice: t("proposals.notice.voted")
  end

  def retire
    if valid_retired_params? && @proposal.update(retired_params.merge(retired_at: Time.current))
      redirect_to proposal_path(@proposal), notice: t("proposals.notice.retired")
    else
      render action: :retire_form
    end
  end

  def retire_form
  end

  def share
  end

  def vote_featured
    @proposal.register_vote(current_user, "yes")
    set_featured_proposal_votes(@proposal)
  end

  def summary
    @proposals = Proposal.for_summary
    @tag_cloud = tag_cloud
  end

  def new
    super
    @resource.proceeding = params[:proceeding]
    @resource.sub_proceeding = params[:sub_proceeding]
  end

  def disable_recommendations
    if current_user.update(recommended_proposals: false)
      redirect_to proposals_path, notice: t("proposals.index.recommendations.actions.success")
    else
      redirect_to proposals_path, error: t("proposals.index.recommendations.actions.error")
    end
  end

  def publish
    @proposal.publish
    redirect_to share_proposal_path(@proposal), notice: t("proposals.notice.published")
  end

  def borought
    @district = Geozone.find(params[:geozone])
    @proposals = Proposal.where(geozone_id: params[:geozone],comunity_hide: true)
  end

  private

    def proposal_params
      params.require(:proposal).permit(:title, :author_id, :summary, :description, :video_url,
                                       :responsible_name, :tag_list, :terms_of_service,
                                       :geozone_id, :proceeding, :sub_proceeding, :skip_map,
                                       image_attributes: image_attributes,
                                       documents_attributes: [:id, :title, :attachment,
                                       :cached_attachment, :user_id, :_destroy],
                                       map_location_attributes: [:latitude, :longitude, :zoom])
    end

    

    def retired_params
      params.require(:proposal).permit(:retired_reason, :retired_explanation)
    end

    def valid_retired_params?
      @proposal.errors.add(:retired_reason, I18n.t("errors.messages.blank")) if params[:proposal][:retired_reason].blank?
      @proposal.errors.add(:retired_explanation, I18n.t("errors.messages.blank")) if params[:proposal][:retired_explanation].blank?
      @proposal.errors.empty?
    end

    def resource_model
      Proposal
    end

    def set_featured_proposal_votes(proposals)
      @featured_proposals_votes = current_user ? current_user.proposal_votes(proposals) : {}
    end

    def discard_draft
      @resources = @resources.published
    end

    def discard_archived
      unless @current_order == "archival_date" || params[:selected].present?
        @resources = @resources.not_archived
      end
    end

    def load_retired
      if params[:retired].present?
        @resources = @resources.retired
        @resources = @resources.where(retired_reason: params[:retired]) if Proposal::RETIRE_OPTIONS.include?(params[:retired])
      else
        @resources = @resources.not_retired
      end
    end

    def load_selected
      if params[:selected].present?
        @resources = @resources.selected
      else
        @resources = @resources.not_selected
      end
    end

    def load_featured
      return unless !@advanced_search_terms && @search_terms.blank? && @tag_filter.blank? && params[:retired].blank? && @current_order != "recommendations"
      if Setting["feature.featured_proposals"]
        @featured_proposals = Proposal.not_archived.not_proceedings.unsuccessful
                              .sort_by_confidence_score.limit(Setting["featured_proposals_number"])
        
        if @featured_proposals.present?
          set_featured_proposal_votes(@featured_proposals)
          @resources = @resources.where("proposals.id NOT IN (?)", @featured_proposals.map(&:id))
        end
      end
    end

    def remove_archived_from_order_links
      @valid_orders.delete("archival_date")
    end

    def set_view
      @view = (params[:view] == "minimal") ? "minimal" : "default"
    end

    def hide_proceedings
      @resources = @resources.not_proceedings
    end

    def hide_advanced_search
      @advanced_search_terms = nil
    end

    def custom_search?
      params[:custom_search].present?
    end

    def destroy_map_location_association
      map_location = params[:proposal][:map_location_attributes]
      if map_location && (map_location[:longitude] && map_location[:latitude]).blank? && !map_location[:id].blank?
        MapLocation.destroy(map_location[:id])
      end
    end

    def load_rank
      @proposal_rank ||= Proposal.rank(@proposal)
    end

    def proposals_recommendations
      if Setting["feature.user.recommendations_on_proposals"] && current_user.recommended_proposals
        @recommended_proposals = Proposal.recommendations(current_user).sort_by_random.limit(3)
      end
    end

    def login_user_with_newsletter_token!
      if current_user.present?
        @signed_in_before_voting = true
      elsif newsletter_vote? && newsletter_user&.can?(:newsletter_vote, Proposal)
        sign_in(:user, newsletter_user)
      end
    end

    def newsletter_vote?
      params[:newsletter_token].present?
    end

    def newsletter_user
      User.where(newsletter_token: params[:newsletter_token]).first
    end

end
