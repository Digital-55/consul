class Legislation::Proposal < ApplicationRecord
  VALID_TYPES = %w(proposal question).freeze
  TITLE_MIN_LENGTH = 4
  TITLE_MAX_LENGTH = 500
  DESCRIPTION_MAX_LENGTH = 5000

  include ActsAsParanoidAliases
  include Flaggable
  include Taggable
  include Conflictable
  include Measurable
  include Sanitizable
  include Searchable
  include Filterable
  include Followable
  include Communitable
  include Documentable
  include Notifiable
  include Imageable
  include Randomizable

  belongs_to :other_proposal, class_name: "Legislation::OtherProposal", foreign_key: "legislation_other_proposal_id"
  has_and_belongs_to_many :categories, -> { order(name: :asc) },  :join_table => :legislation_cat_prop, class_name: "Legislation::Category"
  accepts_nested_attributes_for :other_proposal, allow_destroy: true
  accepts_nested_attributes_for :documents, allow_destroy: true
  

  acts_as_votable
  acts_as_paranoid column: :hidden_at

  belongs_to :process, class_name: "Legislation::Process", foreign_key: "legislation_process_id"
  belongs_to :author, -> { with_hidden }, class_name: "User", foreign_key: "author_id"
  belongs_to :geozone

  has_many :comments, as: :commentable
  
  validates :proposal_type, presence: true, inclusion: { in: VALID_TYPES }
  validates :title, presence: true,:if => :is_other_proposal?
  validates :summary, presence: true, unless: ->(p) { p.proposal_type == "question" },:if => :is_other_proposal?
  validates :author, presence: true
  validates :process, presence: true

  validates :title, length: { in: TITLE_MIN_LENGTH..TITLE_MAX_LENGTH },:if => :is_other_proposal?
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
  
  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create

  before_validation :set_responsible_name

  before_save :calculate_hot_score, :calculate_confidence_score

  scope :for_render, -> { includes(:tags) }
  scope :sort_by_hot_score, -> { reorder(hot_score: :desc) }
  scope :sort_by_confidence_score, -> { reorder(confidence_score: :desc) }
  scope :sort_by_created_at,       -> { reorder(created_at: :desc) }
  scope :sort_by_most_commented,   -> { reorder(comments_count: :desc) }
  scope :sort_by_title,            -> { reorder(title: :asc) }
  scope :sort_by_id,               -> { reorder(id: :asc) }
  scope :sort_by_supports,         -> { reorder(cached_votes_score: :desc) }
  scope :sort_by_flags,            -> { order(flags_count: :desc, updated_at: :desc) }
  scope :last_week,                -> { where("proposals.created_at >= ?", 7.days.ago)}
  scope :selected,                 -> { where(selected: true) }
  scope :winners,                  -> { selected.sort_by_confidence_score }
  scope :no_flags_proposals,       -> { where("flags_count = 0  AND type_other_proposal IS NULL").where(ignored_flag_at: nil, hidden_at:nil) }
  scope :no_other_proposal,        -> { where(type_other_proposal: nil)}
  scope :no_flags_other_proposals, -> { where("type_other_proposal IS NOT NULL").where(ignored_flag_at: nil, hidden_at:nil) }
  scope :no_hidden_other_proposals, -> { all_records.with_deleted.where("type_other_proposal IS NOT NULL").where.not(hidden_at: nil) }
  scope :other_with_ignored_flag,  -> { where("type_other_proposal IS NOT NULL").where.not(ignored_flag_at: nil).where(hidden_at: nil) }

  def to_param
    "#{id}-#{title}".parameterize
  end

  def searchable_values
    { title              => "A",
      author.try(:username) => "B",
      tag_list.join(" ") => "B",
      geozone.try(:name) => "B",
      summary            => "C",
      description        => "D"}
  end

  def self.search(terms)
    by_code = search_by_code(terms.strip)
    by_code.present? ? by_code : pg_search(terms)
  end

  def self.search_by_code(terms)
    matched_code = match_code(terms)
    results = where(id: matched_code[1]) if matched_code
    return results if results.present? && results.first.code == terms
  end

  def self.match_code(terms)
    /\A#{Setting["proposal_code_prefix"]}-\d\d\d\d-\d\d-(\d*)\z/.match(terms)
  end

  def likes
    cached_votes_up
  end

  def dislikes
    cached_votes_down
  end

  def total_votes
    cached_votes_total
  end

  def votes_score
    cached_votes_score
  end

  def voters
    User.active.where(id: votes_for.voters)
  end

  def editable?
    total_votes <= Setting["max_votes_for_proposal_edit"].to_i
  end

  def editable_by?(user)
    author_id == user.id && editable?
  end

  def votable_by?(user)
    user && user.level_two_or_three_verified?
  end

  def register_vote(user, vote_value)
    vote_by(voter: user, vote: vote_value) if votable_by?(user)
  end

  def code
    "#{Setting["proposal_code_prefix"]}-#{created_at.strftime("%Y-%m")}-#{id}"
  end

  def after_commented
    save # update cache when it has a new comment
  end

  def calculate_hot_score
    self.hot_score = ScoreCalculator.hot_score(self)
  end

  def calculate_confidence_score
    self.confidence_score = ScoreCalculator.confidence_score(total_votes, total_votes)
  end

  def after_hide
    tags.each{ |t| t.decrement_custom_counter_for("legislation/proposals") }
  end

  def after_restore
    tags.each{ |t| t.increment_custom_counter_for("legislation/proposals") }
  end

  def is_proposal?
    proposal_type == "proposal"
  end

  def is_question?
    proposal_type == "question"
  end

  def is_other_proposal?
    self.type_other_proposal.blank?
  end

  protected

    def set_responsible_name
      if author && author.document_number?
        self.responsible_name = author.document_number
      end
    end
end
