class Poll < ApplicationRecord
  require_dependency "poll/answer"

  AGE_STEPS = [16,20,25,30,35,40,45,50,55,60,65]

  include Imageable
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases
  include Notifiable
  include Sluggable
  include StatsVersionable
  include Reportable

  translates :name,        touch: true
  translates :summary,     touch: true
  translates :description, touch: true
  include Globalizable

  RECOUNT_DURATION = 1.week

  has_many :booth_assignments, class_name: "Poll::BoothAssignment"
  has_many :booths, through: :booth_assignments
  has_many :partial_results, through: :booth_assignments
  has_many :recounts, through: :booth_assignments
  has_many :voters
  has_many :officer_assignments, through: :booth_assignments
  has_many :officers, through: :officer_assignments
  has_many :questions, inverse_of: :poll, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :ballot_sheets

  has_and_belongs_to_many :geozones
  belongs_to :author, -> { with_hidden }, class_name: "User", foreign_key: "author_id"
  belongs_to :related, polymorphic: true
  belongs_to :budget

  accepts_nested_attributes_for :questions

  validates_translation :name, presence: true
  validate :date_range
  validate :only_one_active, unless: :public?

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  scope :for, ->(element) { where(related: element) }
  scope :public_polls, -> { where(related: nil) }
  scope :current,  -> { where("starts_at <= ? and ? <= ends_at", Date.current.beginning_of_day, Date.current.beginning_of_day) }
  scope :expired,  -> { where("ends_at < ?", Date.current.beginning_of_day) }
  scope :recounting, -> { Poll.where(ends_at: (Date.current.beginning_of_day - RECOUNT_DURATION)..Date.current.beginning_of_day) }
  scope :published, -> { where("published = ?", true) }
  scope :by_geozone_id, ->(geozone_id) { where(geozones: {id: geozone_id}.joins(:geozones)) }
  scope :public_for_api, -> { all }
  scope :with_nvotes, -> { where.not(nvotes_poll_id: nil) }
  scope :not_budget,    -> { where(budget_id: nil) }
  scope :created_by_admin, -> { where(related_type: nil) }

  def self.translate_column_names
    [:name, :description, :summary ]
  end

  def self.sort_for_list
    all.sort do |poll, another_poll|
      if poll.geozone_restricted? == another_poll.geozone_restricted?
        [poll.starts_at, poll.name] <=> [another_poll.starts_at, another_poll.name]
      else
        if poll.geozone_restricted?
          1
        else
          -1
        end
      end
    end
  end

  def self.overlaping_with(poll)
    where("? < ends_at and ? >= starts_at", poll.starts_at.beginning_of_day,
                                            poll.ends_at.end_of_day).where.not(id: poll.id)
                                            .where(related: poll.related)
  end

  def title
    name
  end

  def current?(timestamp = Date.current.beginning_of_day)
    starts_at <= timestamp && timestamp <= ends_at
  end

  def expired?(timestamp = Date.current.beginning_of_day)
    ends_at < timestamp
  end

  def recounts_confirmed?
    ends_at < 1.month.ago
  end

  def self.current_or_recounting
    current + recounting
  end

  def answerable_by?(user)
    user.present? &&
      user.level_two_or_three_verified? &&
      current? &&
      (!geozone_restricted || geozone_ids.include?(user.geozone_id))
  end

  def self.answerable_by(user)
    return none if user.nil? || user.unverified?
    current.joins('LEFT JOIN "geozones_polls" ON "geozones_polls"."poll_id" = "polls"."id"')
           .where("geozone_restricted = ? OR geozones_polls.geozone_id = ?", false, user.geozone_id)
  end

  def self.votable_by(user)
    answerable_by(user).
    not_voted_by(user)
  end

  def votable_by?(user)
    return false if user_has_an_online_ballot?(user)
    answerable_by?(user) &&
    not_voted_by?(user)
  end

  def user_has_an_online_ballot?(user)
    budget.present? && budget.ballots.find_by(user: user)&.lines.present?
  end

  def self.not_voted_by(user)
    where("polls.id not in (?)", poll_ids_voted_by(user))
  end

  def self.poll_ids_voted_by(user)
    return -1 if Poll::Voter.where(user: user).empty?

    Poll::Voter.where(user: user).pluck(:poll_id)
  end

  def not_voted_by?(user)
    Poll::Voter.where(poll: self, user: user).empty?
  end

  def voted_by?(user)
    Poll::Voter.where(poll: self, user: user).exists?
  end

  def voted_in_booth?(user)
    Poll::Voter.where(poll: self, user: user, origin: "booth").exists?
  end

  def voted_in_web?(user)
    Poll::Voter.where(poll: self, user: user, origin: "web").exists?
  end

  def date_range
    unless starts_at.present? && ends_at.present? && starts_at <= ends_at
      errors.add(:starts_at, I18n.t("errors.messages.invalid_date_range"))
    end
  end

  def self.server_shared_key
    Rails.application.secrets.nvotes_shared_key || ENV["nvotes_shared_key"]
  end

  def self.server_url
    Rails.application.secrets.nvotes_server_url || ENV["nvotes_server_url"]
  end

  def budget_poll?
    budget.present?
  end

  def generate_slug?
    slug.nil?
  end

  def only_one_active
    return unless starts_at.present?
    return unless ends_at.present?
    return unless Poll.overlaping_with(self).any?
    errors.add(:starts_at, I18n.t("activerecord.errors.messages.another_poll_active"))
  end

  def public?
    related.nil?
  end

  def answer_count
    Poll::Answer.where(question: questions).count
  end
end
