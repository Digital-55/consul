class Budget
  class Investment < ApplicationRecord
    SORTING_OPTIONS = {id: "id", title: "title", supports: "cached_votes_up + physical_votes"}.freeze

    include Rails.application.routes.url_helpers    
    include Measurable
    include Sanitizable
    include Taggable
    include Searchable
    include Reclassification
    include Followable
    include Communitable
    include Imageable
    include Mappable
    include Documentable

    acts_as_votable
    acts_as_paranoid column: :hidden_at
    include ActsAsParanoidAliases
    include Relationable
    include Notifiable    
    include Flaggable
    include Milestoneable
    include Randomizable
    include Filterable

    belongs_to :author, -> { with_hidden }, class_name: "User", foreign_key: "author_id"
    belongs_to :heading
    belongs_to :group
    belongs_to :budget
    belongs_to :administrator

    has_many :valuator_assignments, dependent: :destroy
    has_many :valuators, through: :valuator_assignments

    has_many :valuator_group_assignments, dependent: :destroy
    has_many :valuator_groups, through: :valuator_group_assignments

    has_many :comments, -> {where(valuation: false)}, as: :commentable, class_name: "Comment"
    has_many :valuations, -> {where(valuation: true)}, as: :commentable, class_name: "Comment"

    validates :title, presence: true
    validates :author, presence: true
    validates :description, presence: true
    validates :heading_id, presence: true
    validates :unfeasibility_explanation, presence: { if: :unfeasibility_explanation_required? }
    validates :price, presence: { if: :price_required? }

    validates :title, length: { in: 4..Budget::Investment.title_max_length }
    validates :description, length: { maximum: Budget::Investment.description_max_length }
    validates :terms_of_service, acceptance: { allow_nil: false }, on: :create

    scope :sort_by_confidence_score, -> { reorder(confidence_score: :desc, id: :desc) }
    scope :sort_by_ballots,          -> { reorder(ballot_lines_count: :desc, id: :desc) }
    scope :sort_by_price,            -> { reorder(price: :desc, confidence_score: :desc, id: :desc) }

    scope :sort_by_id, -> { order("id DESC") }
    scope :sort_by_title, -> { order("title ASC") }
    scope :sort_by_supports, -> { order("cached_votes_up + physical_votes DESC").order(id: :desc) }

    scope :valuation_open,              -> { where(valuation_finished: false) }
    scope :without_admin,               -> { valuation_open.where(administrator_id: nil) }
    scope :without_valuator_group,      -> { where(valuator_group_assignments_count: 0) }
    scope :without_valuator,            -> { valuation_open.without_valuator_group.where(valuator_assignments_count: 0) }
    scope :under_valuation,             -> { valuation_open.valuating.where("administrator_id IS NOT ?", nil) }
    scope :managed,                     -> { valuation_open.where(valuator_assignments_count: 0).where("administrator_id IS NOT ?", nil) }
    scope :valuating,                   -> { valuation_open.where("valuator_assignments_count > 0 OR valuator_group_assignments_count > 0" ) }
    scope :visible_to_valuators,        -> { where(visible_to_valuators: true) }
    scope :valuation_finished,          -> { where(valuation_finished: true) }
    scope :valuation_finished_feasible, -> { where(valuation_finished: true, feasibility: "feasible") }
    scope :feasible,                    -> { where(feasibility: "feasible") }
    scope :unfeasible,                  -> { where(feasibility: "unfeasible") }
    scope :not_unfeasible,              -> { where.not(feasibility: "unfeasible") }
    scope :undecided,                   -> { where(feasibility: "undecided") }
    scope :with_supports,               -> { where("cached_votes_up > 0") }
    scope :selected,                    -> { feasible.where(selected: true) }
    scope :compatible,                  -> { where(incompatible: false) }
    scope :incompatible,                -> { where(incompatible: true) }
    scope :winners,                     -> { selected.compatible.where(winner: true) }
    scope :unselected,                  -> { not_unfeasible.where(selected: false) }
    scope :last_week,                   -> { where("created_at >= ?", 7.days.ago)}
    scope :sort_by_flags,               -> { order(flags_count: :desc, updated_at: :desc) }
    scope :sort_by_created_at,          -> { reorder(created_at: :desc) }

    scope :by_budget,         ->(budget)      { where(budget: budget) }
    scope :by_group,          ->(group_id)    { where(group_id: group_id) }
    scope :by_heading,        ->(heading_id)  { where(heading_id: heading_id) }
    scope :by_admin,          ->(admin_id)    { where(administrator_id: admin_id) }
    scope :by_tag,            ->(tag_name)    { tagged_with(tag_name) }
    scope :by_valuator,       ->(valuator_id) { where("budget_valuator_assignments.valuator_id = ?", valuator_id).joins(:valuator_assignments) }
    scope :by_valuator_group, ->(valuator_group_id) { where("budget_valuator_group_assignments.valuator_group_id = ?", valuator_group_id).joins(:valuator_group_assignments) }
    scope :accesible_by_valuator, ->(valuator) do
      direct_access = by_valuator(valuator&.id)
      group_access = by_valuator_group(valuator&.valuator_group_id)
      visible_to_valuators.where(id: (direct_access.pluck(:id) + group_access.pluck(:id)).uniq)
    end

    scope :for_render, -> { includes(:heading) }

    before_create :set_original_heading_id
    before_save :calculate_confidence_score
    after_save :recalculate_heading_winners
    before_validation :set_responsible_name
    before_validation :set_denormalized_ids

    def comments_count
      comments.filtered.count
    end

    def url
      budget_investment_path(budget, self)
    end

    def self.filter_params(params)
      params.permit(:heading_id,:administrator_id,:tag_name,:valuator_or_group_id, :title_or_id, :min_total_supports,
                    :advanced_filters => [])
    end

    def self.scoped_filter(params, current_filter)
      budget  = Budget.find_by_slug_or_id params[:budget_id]
      results = Investment.by_budget(budget)

      results = results.where("cached_votes_up + physical_votes >= ?",
                              params[:min_total_supports])                 if params[:min_total_supports].present?
      results = results.where(group_id: params[:group_id])                 if params[:group_id].present?
      results = results.by_tag(params[:tag_name])                          if params[:tag_name].present?
      results = results.by_heading(params[:heading_id])                    if params[:heading_id].present?
      results = results.by_valuator(params[:valuator_id])                  if params[:valuator_id].present?
      results = results.by_valuator_group(params[:valuator_group_id])      if params[:valuator_group_id].present?
      results = results.by_admin(params[:administrator_id])                if params[:administrator_id].present?
      results = advanced_filters(params, results)                          if params[:advanced_filters].present?
      results = search_by_title_or_id(params[:title_or_id].strip, results) if params[:title_or_id]

      results = results.send(current_filter)                        if current_filter.present?
      
      results.includes(:heading, :group, :budget, administrator: :user, valuators: :user)
    end

    def self.advanced_filters(params, results)
      ids = []
      ids += results.valuation_finished_feasible.pluck(:id)   if params[:advanced_filters].include?("feasible")
      ids += results.where(selected: true).pluck(:id)         if params[:advanced_filters].include?("selected")
      ids += results.undecided.pluck(:id)                     if params[:advanced_filters].include?("undecided")
      ids += results.unfeasible.pluck(:id)                    if params[:advanced_filters].include?("unfeasible")
      results.where("budget_investments.id IN (?)", ids)
    end

    def self.order_filter(params)
      sorting_key = params[:sort_by]&.downcase&.to_sym
      allowed_sort_option = SORTING_OPTIONS[sorting_key]

      if allowed_sort_option.present?
        direction = params[:direction] == "desc" ? "desc" : "asc"
        order("#{allowed_sort_option} #{direction}")
      else
        sort_by_supports
      end
    end

    def self.limit_results(budget, params, results)
      max_per_heading = params[:max_per_heading].to_i
      return results if max_per_heading <= 0

      ids = []
      budget.headings.pluck(:id).each do |hid|
        ids += Investment.where(heading_id: hid).order(confidence_score: :desc).limit(max_per_heading).pluck(:id)
      end
    end

    def self.search_by_title_or_id(title_or_id, results)
      if title_or_id =~ /^[0-9]+$/
        results.where(id: title_or_id)
      else
        results.where("title ILIKE ?", "%#{title_or_id}%")
      end
    end

    def searchable_values
      { title              => "A",
        author.try(:username)    => "B",
        heading.try(:name) => "B",
        tag_list.join(" ") => "B",
        description        => "C"
      }
    end

    def self.search(terms)
      pg_search(terms)
    end

    def self.by_heading(heading)
      where(heading_id: heading == "all" ? nil : heading.presence)
    end

    def undecided?
      feasibility == "undecided"
    end

    def feasible?
      feasibility == "feasible"
    end

    def unfeasible?
      feasibility == "unfeasible"
    end

    def unfeasibility_explanation_required?
      unfeasible? && valuation_finished?
    end

    def price_required?
      feasible? && valuation_finished?
    end

    def unfeasible_email_pending?
      unfeasible_email_sent_at.blank? && unfeasible? && valuation_finished?
    end

    def total_votes
      cached_votes_up + physical_votes
    end

    def code
      "#{created_at.strftime("%Y")}-#{id}" + (administrator.present? ? "-A#{administrator.id}" : "")
    end

    def send_unfeasible_email
      begin
        Mailer.budget_investment_unfeasible(self).deliver_now!
      rescue => e
        begin
          Rails.logger.error("ERROR-MAILER: #{e}")
        rescue
        end
      end
      update(unfeasible_email_sent_at: Time.current)
    end

    def reason_for_not_being_selectable_by(user)
      return permission_problem(user) if permission_problem?(user)
      return :different_heading_assigned unless valid_heading?(user)

      return :no_selecting_allowed unless budget.selecting?
    end

    def reason_for_not_being_ballotable_by(user, ballot)
      return permission_problem(user)         if permission_problem?(user)
      return :not_selected                    unless selected?
      return :no_ballots_allowed              unless budget.balloting?
      return :different_heading_assigned_html unless ballot.valid_heading?(heading)
      return :not_enough_money_html           if ballot.present? && !enough_money?(ballot)
      return :casted_offline                  if ballot.casted_offline?
    end

    def permission_problem(user)
      return :not_logged_in unless user
      return :organization  if user.organization?
      return :not_verified  unless user.can?(:vote, Budget::Investment)
      nil
    end

    def permission_problem?(user)
      permission_problem(user).present?
    end

    def selectable_by?(user)
      reason_for_not_being_selectable_by(user).blank?
    end

    def valid_heading?(user)
      reclassification?(user) ||
      voted_in?(heading, user) ||
      can_vote_in_another_heading?(user)
    end

    def can_vote_in_another_heading?(user)
      user.headings_voted_within_group(group).count < group.max_votable_headings
    end

    def reclassification?(user)
      user.headings_voted_within_group(group).count > 1 &&
      user.headings_voted_within_group(group).where(id: heading_id).exists?
    end

    def headings_voted_by_user(user)
      user.votes.for_budget_investments(budget.investments.where(group: group)).votables.map(&:heading_id).uniq
    end

    def voted_in?(heading, user)
      user.headings_voted_within_group(group).where(id: heading.id).exists?
    end

    def ballotable_by?(user)
      reason_for_not_being_ballotable_by(user).blank?
    end

    def enough_money?(ballot)
      available_money = ballot.amount_available(heading)
      price.to_i <= available_money
    end

    def register_selection(user)
      vote_by(voter: user, vote: "yes") if selectable_by?(user)
    end

    def calculate_confidence_score
      self.confidence_score = ScoreCalculator.confidence_score(total_votes, total_votes)
    end

    def recalculate_heading_winners
      Budget::Result.new(budget, heading).calculate_winners if incompatible_changed?
    end

    def set_responsible_name
      self.responsible_name = author.try(:document_number) if author.try(:document_number).present?
    end

    def should_show_aside?
      (budget.selecting? && !unfeasible?) ||
        (budget.balloting? && feasible?) ||
        (budget.valuating? && !unfeasible?)
    end

    def should_show_votes?
      budget.selecting?
    end

    def should_show_vote_count?
      budget.valuating?
    end

    def should_show_ballots?
      budget.balloting? && selected?
    end

    def should_show_price?
      selected? && price.present? && budget.published_prices?
    end

    def should_show_price_explanation?
      should_show_price? && price_explanation.present?
    end

    def should_show_unfeasibility_explanation?
      unfeasible? && valuation_finished? && unfeasibility_explanation.present?
    end

    def formatted_price
      budget.formatted_amount(price)
    end

    def self.apply_filters_and_search(_budget, params, current_filter = nil)
      investments = all
      investments = investments.send(current_filter)             if current_filter.present?
      investments = investments.by_heading(params[:heading_id])  if params[:heading_id].present?
      investments = investments.search(params[:search])          if params[:search].present?
      investments = investments.filter_by(params[:advanced_search]) if params[:advanced_search].present?
      investments
    end

    

    def self.by_heading(heading_id)
      heading_ids = [heading_id]
      if Budget::Heading.where(slug: heading_id).exists?
        heading_ids << Budget::Heading.where(slug: heading_id).first.id.to_s
      end
      where(heading_id: heading_ids)
    end

    def assigned_valuators
      self.valuators.collect(&:description_or_name).compact.join(", ").presence
    end

    def assigned_valuation_groups
      self.valuator_groups.collect(&:name).compact.join(", ").presence
    end

    def valuation_tag_list
      tag_list_on(:valuation)
    end

    def valuation_tag_list=(tags)
      set_tag_list_on(:valuation, tags)
    end

    def self.with_milestone_status_id(status_id)
      joins(:milestones).includes(:milestones).select do |investment|
        investment.milestone_status_id == status_id.to_i
      end
    end

    def milestone_status_id
      milestones.published.with_status.order_by_publication_date.last&.status_id
    end

    def valuation_tag_list
      tag_list_on(:valuation)
    end

    def valuation_tag_list=(tags)
      set_tag_list_on(:valuation, tags)
    end

    def self.with_milestone_status_id(status_id)
      includes(milestones: :translations).select do |investment|
        investment.milestone_status_id == status_id.to_i
      end
    end

    def milestone_status_id
      milestones.published.with_status.order_by_publication_date.last&.status_id
    end

    private

      def set_denormalized_ids
        self.group_id = heading.try(:group_id) if heading_id_changed?
        self.budget_id ||= heading.try(:group).try(:budget_id)
      end

      def set_original_heading_id
        self.original_heading_id = heading_id
      end

  end
end
