class ProposalNotification < ApplicationRecord
  include Graphqlable
  include Notifiable

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :proposal

  validates :title, presence: true
  validates :body, presence: true
  validates :proposal, presence: true
  validate :minimum_interval

  scope :public_for_api,           -> { where(proposal_id: Proposal.public_for_api.pluck(:id)) }
  scope :sort_by_created_at,       -> { reorder(created_at: :desc) }
  scope :sort_by_moderated,       -> { reorder(moderated: :desc) }

  scope :moderated, -> { where(moderated: true) }
  scope :not_moderated, -> { where(moderated: false) }
  scope :pending_review, -> { moderated.where(ignored_at: nil) }
  scope :ignored, -> { moderated.where.not(ignored_at: nil) }

  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  after_create :set_author

  def minimum_interval
    return true if proposal.try(:notifications).blank?
    interval = Setting[:proposal_notification_minimum_interval_in_days]
    minimum_interval = (Time.current - interval.to_i.days).to_datetime
    if proposal.notifications.last.created_at > minimum_interval
      errors.add(:title, I18n.t("activerecord.errors.models.proposal_notification.attributes.minimum_interval.invalid", interval: interval))
    end
  end

  def self.public_columns_for_api
    ["title",
     "body",
     "proposal_id",
     "created_at",
    "author_name"]
  end

  def author_name
    author.try(:name)
  end

  def public_for_api?
    return false unless proposal.present?
    return false if proposal.hidden?
    return false unless proposal.public_for_api?
    return true
  end

  def notifiable
    proposal
  end

  def moderate_system_email(moderator)
    Notification.where(notifiable_type: "ProposalNotification", notifiable: self).destroy_all
    Activity.log(moderator, :hide, self)
  end

  def ignore_flag
    update(ignored_at: Time.current)
  end

  def ignored?
    ignored_at.present?
  end

  def after_restore
    update(moderated: false)
  end

  private

  def set_author
    self.update(author_id: self.proposal.author_id) if self.proposal
  end

end
