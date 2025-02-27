class Comment < ApplicationRecord
  include Flaggable
  include HasPublicAuthor
  include Graphqlable
  include Notifiable

  COMMENTABLE_TYPES = %w(Debate Proposal Budget::Investment Poll Topic Legislation::Question
                        Legislation::Annotation Legislation::Proposal
                        Poll::Question ProbeOption).freeze

  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases
  acts_as_votable
  has_ancestry touch: true

  attr_accessor :as_moderator, :as_administrator, :is_offensive

  validates :body, presence: true
  validates :user, presence: true

  validates :commentable_type, inclusion: { in: COMMENTABLE_TYPES }

  validate :validate_body_length, unless: -> { valuation }
  validate :comment_valuation, if: -> { valuation }

  has_many :moderated_texts, through: :moderated_contents
  has_many :moderated_contents, dependent: :destroy, foreign_key: "moderable_id", as: :moderable

  belongs_to :commentable, -> { with_hidden }, polymorphic: true, counter_cache: true, touch: true
  belongs_to :user, -> { with_hidden }

  before_save :calculate_confidence_score

  scope :for_render, -> { with_hidden.includes(user: :organization) }
  scope :with_visible_author, -> { joins(:user).where("users.hidden_at IS NULL") }
  scope :not_as_admin_or_moderator, -> do
    where("administrator_id IS NULL").where("moderator_id IS NULL")
  end
  scope :sort_by_flags, -> { order(flags_count: :desc, updated_at: :desc) }

  scope :public_for_api, -> do
    not_valuations
      .where(%{(comments.commentable_type = 'Debate' and comments.commentable_id in (?)) or
            (comments.commentable_type = 'Proposal' and comments.commentable_id in (?)) or
            (comments.commentable_type = 'Poll' and comments.commentable_id in (?)) or
            (comments.commentable_type = 'Topic' and comments.commentable_id in (?))},
          Debate.public_for_api.pluck(:id),
          Proposal.public_for_api.pluck(:id),
          Poll.public_for_api.pluck(:id),
          Topic.public_for_api.pluck(:id))
  end

  scope :sort_by_most_voted, -> { order(confidence_score: :desc, created_at: :desc) }
  scope :sort_descendants_by_most_voted, -> { order(confidence_score: :desc, created_at: :asc) }

  scope :sort_by_newest, -> { order(created_at: :desc) }
  scope :sort_descendants_by_newest, -> { order(created_at: :desc) }

  scope :sort_by_oldest, -> { order(created_at: :asc) }
  scope :sort_descendants_by_oldest, -> { order(created_at: :asc) }

  scope :not_valuations, -> { where(valuation: false) }

  scope :filtered, -> {
    includes(:moderated_contents)
      .joins("LEFT JOIN moderated_contents
        ON moderated_contents.moderable_id = comments.id
        AND moderated_contents.moderable_type = 'Comment'")
      .where("moderated_contents.moderable_id IS NULL
        OR moderated_contents.declined_at IS NOT NULL").distinct
  }

  after_create :call_after_commented

  def decrement_comments_count
    return if self.commentable.nil?
    self.commentable.class.decrement_counter(:comments_count, self.commentable_id)
  end

  def increment_comments_count
    return if self.commentable.nil?
    self.commentable.class.increment_counter(:comments_count, self.commentable_id)
  end

  def self.build(commentable, user, body, p_id = nil, valuation = false)
    new(commentable: commentable,
        user_id:     user.id,
        body:        body,
        parent_id:   p_id,
        valuation:   valuation)
  end

  def self.find_commentable(c_type, c_id)
    c_type.constantize.find(c_id)
  end

  def author_id
    user_id
  end

  def author
    user
  end

  def author=(author)
    self.user = author
  end

  def total_votes
    cached_votes_total
  end

  def total_likes
    cached_votes_up
  end

  def total_dislikes
    cached_votes_down
  end

  def as_administrator?
    administrator_id.present?
  end

  def as_moderator?
    moderator_id.present?
  end

  def after_hide
    commentable_type.constantize.with_hidden.reset_counters(commentable_id, :comments)
  end

  def after_restore
    commentable_type.constantize.with_hidden.reset_counters(commentable_id, :comments)
  end

  def reply?
    !root?
  end

  def call_after_commented
    commentable.try(:after_commented)
  end

  def self.body_max_length
    Setting["comments_body_max_length"].to_i
  end

  def calculate_confidence_score
    self.confidence_score = ScoreCalculator.confidence_score(cached_votes_total,
                                                             cached_votes_up)
  end

  def self.public_columns_for_api
    ["id",
     "commentable_id",
     "commentable_type",
     "body",
     "created_at",
     "cached_votes_total",
     "cached_votes_up",
     "cached_votes_down",
     "ancestry",
     "confidence_score"]
  end

  def public_for_api?
    return false if valuation
    return false unless commentable.present?
    return false if commentable.hidden?
    return false unless ["Proposal", "Debate"].include? commentable_type
    return false unless commentable.public_for_api?
    return true
  end

  def check_for_offenses
    moderated_words = ::ModeratedText.all.pluck(:text)
    return if moderated_words.empty?
    regex = /\b(?:#{::Regexp.union(moderated_words).source})\b/i

    self.body.scan(regex).map(&:downcase)
  end

  def allows_editing?
    moderated_contents.any? &&
      moderated_contents.where("confirmed_at IS NULL and declined_at IS NULL").any?
  end

  def confirmed_moderation?
    moderated_contents.where("confirmed_at IS NOT NULL").any?
  end

  private

    def validate_body_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :body,
        maximum: Comment.body_max_length)
      validator.validate(self)
    end

    def comment_valuation
      unless author.can?(:comment_valuation, commentable)
        errors.add(:valuation, :cannot_comment_valuation)
      end
    end
end
