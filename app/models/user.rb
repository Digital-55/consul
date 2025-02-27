class User < ApplicationRecord

  include Verification
  require "date"

  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :password_expirable, :secure_validatable,
         :lockable, :timeoutable, authentication_keys: [:login]

  acts_as_voter
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  include Graphqlable
  has_one :superadmin
  has_one :administrator
  has_one :sures_administrator
  has_one :section_administrator
  has_one :moderator
  has_one :valuator
  has_one :manager
  has_one :consultant
  has_one :editor
  has_one :poll_officer, class_name: "Poll::Officer"
  has_one :organization
  has_one :lock
  has_one :ballot
  has_many :flags, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :debates, -> { with_hidden }, foreign_key: :author_id, dependent: :destroy
  has_many :proposals, -> { with_hidden }, foreign_key: :author_id, dependent: :destroy
  has_many :budget_investments, -> { with_hidden }, foreign_key: :author_id, class_name: "Budget::Investment", dependent: :destroy
  has_many :comments, -> { with_hidden }, dependent: :destroy
  has_many :failed_census_calls, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :direct_messages_sent,     class_name: "DirectMessage", foreign_key: :sender_id, dependent: :destroy
  has_many :direct_messages_received, class_name: "DirectMessage", foreign_key: :receiver_id, dependent: :destroy
  has_many :legislation_answers, class_name: "Legislation::Answer", dependent: :destroy, inverse_of: :user
  has_many :follows, dependent: :destroy
  belongs_to :geozone
  belongs_to :adress
  belongs_to :profile
  attr_accessor :enable_document_validation
  validates :username, presence: true, if: :username_required?
  validates :username, uniqueness: { scope: :registering_with_oauth }, if: :username_required?
  validates :email, presence: true
  validates :document_type, presence: true, if: :enable_document_validation
  validates :document_number, uniqueness: { scope: :document_type }, allow_nil: true, if: :enable_document_validation

  validate :validate_username_length

  validates :official_level, inclusion: {in: 0..5}
  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create
  validates_format_of :phone_number, :with => /\A(\+34|0034|34)?[6|7|8|9][0-9]{8}\z/, allow_blank: true

  validates_associated :organization, message: false

  accepts_nested_attributes_for :organization, update_only: true
  accepts_nested_attributes_for :adress
  accepts_nested_attributes_for :profile

  attr_accessor :skip_password_validation
  attr_accessor :use_redeemable_code
  attr_accessor :login

  scope :administrators, -> { joins(:administrator) }
  scope :moderators,     -> { joins(:moderator) }
  scope :organizations,  -> { joins(:organization) }
  scope :officials,      -> { where("official_level > 0") }
  scope :male,           -> { where(gender: "male") }
  scope :female,         -> { where(gender: "female") }
  scope :newsletter,     -> { where(newsletter: true) }
  scope :for_render,     -> { includes(:organization) }
  scope :by_document,    ->(document_type, document_number) do
    where(document_type: document_type, document_number: document_number)
  end
  scope :email_digest,   -> { where(email_digest: true) }
  scope :active,         -> { where(erased_at: nil) }
  scope :erased,         -> { where.not(erased_at: nil) }
  scope :public_for_api, -> { all }
  scope :by_comments,    ->(query, topics_ids) { joins(:comments).where(query, topics_ids).distinct }
  scope :by_authors,     ->(author_ids) { where("users.id IN (?)", author_ids) }
  scope :by_username_email_or_document_number, ->(search_string) do
    string = "%#{search_string}%"
    where("username ILIKE ? OR email ILIKE ? OR document_number ILIKE ?", string, string, string)
  end
  scope :between_ages, -> (from, to) do
    where(
      "date_of_birth > ? AND date_of_birth < ?",
      to.years.ago.beginning_of_year,
      from.years.ago.end_of_year
    )
  end

  before_validation :clean_document_number

  # Get the existing user by email if the provider gives us a verified email.
  def self.first_or_initialize_for_oauth(auth)
    oauth_email           = auth.info.email
    oauth_email_confirmed = oauth_email.present? && (auth.info.verified || auth.info.verified_email)
    oauth_user            = User.find_by(email: oauth_email) if oauth_email_confirmed

    oauth_user || User.new(
      username:  auth.info.name || auth.uid,
      email: oauth_email,
      oauth_email: oauth_email,
      password: Devise.friendly_token[0, 20],
      terms_of_service: "1",
      confirmed_at: oauth_email_confirmed ? DateTime.current : nil
    )
  end

  def name
    organization? ? organization.name : username
  end

  def phone
    confirmed_phone || phone_number
  end

  def debate_votes(debates)
    voted = votes.for_debates(Array(debates).map(&:id))
    voted.each_with_object({}) { |v, h| h[v.votable_id] = v.value }
  end

  def topic_votes(topics)
    voted = votes.for_topics(Array(topics).map(&:id))
    voted.each_with_object({}) { |v, h| h[v.votable_id] = v.value }
  end

  def proposal_votes(proposals)
    voted = votes.for_proposals(Array(proposals).map(&:id))
    voted.each_with_object({}) { |v, h| h[v.votable_id] = v.value }
  end

  def legislation_proposal_votes(proposals)
    voted = votes.for_legislation_proposals(proposals)
    voted.each_with_object({}) { |v, h| h[v.votable_id] = v.value }
  end

  def budget_investment_votes(budget_investments)
    voted = votes.for_budget_investments(budget_investments)
    voted.each_with_object({}) { |v, h| h[v.votable_id] = v.value }
  end

  def comment_flags(comments)
    comment_flags = flags.for_comments(comments)
    comment_flags.each_with_object({}){ |f, h| h[f.flaggable_id] = true }
  end

  def voted_for_any?(class_name)
    votes.for_type(class_name).any?
  end

  def voted_in_group?(group)
    votes.for_budget_investments(Budget::Investment.where(group: group)).exists?
  end

  def headings_voted_within_group(group)
    Budget::Heading.where(id: voted_investments.by_group(group).pluck(:heading_id))
  end

  def voted_investments
    Budget::Investment.where(id: votes.for_budget_investments.pluck(:votable_id))
  end

  def super_administrator?
    !Superadministrator.find_by(user_id: self.id).blank?
  end

  def administrator?
    !Administrator.find_by(user_id: self.id).blank? || self.sures? || self.super_administrator? || self.section_administrator? || self.consultant? || 
        self.editor? || self.parbudget_editor? || self.parbudget_reader? || self.complan_editor? || self.complan_reader?
  end

  def sures?
    !SuresAdministrator.find_by(user_id: self.id).blank?
  end

  def section_administrator?
    !SectionAdministrator.find_by(user_id: self.id).blank?
  end

  def moderator?
    moderator.present?
  end

  def valuator?
    valuator.present?
  end

  def manager?
    manager.present?
  end

  def consultant?
    !Consultant.find_by(user_id: self.id).blank?
  end

  def editor?
    !Editor.find_by(user_id: self.id).blank?
  end

  def parbudget_editor?
    !Parbudget::Editor.find_by(user_id: self.id).blank?
  end

  def parbudget_reader?
    !Parbudget::Reader.find_by(user_id: self.id).blank?
  end

  def complan_editor?
    !Complan::Editor.find_by(user_id: self.id).blank?
  end

  def complan_reader?
    !Complan::Reader.find_by(user_id: self.id).blank?
  end

  def poll_officer?
    poll_officer.present?
  end

  def officing_voter?
    officing_voter.present?
  end

  def organization?
    organization.present?
  end

  def verified_organization?
    organization && organization.verified?
  end

  def official?
    official_level && official_level > 0
  end

  def add_official_position!(position, level)
    return if position.blank? || level.blank?
    update official_position: position, official_level: level.to_i
  end

  def remove_official_position!
    update official_position: nil, official_level: 0
  end

  def has_official_email?
    domain = Setting["email_domain_for_officials"]
    email.present? && ((email.end_with? "@#{domain}") || (email.end_with? ".#{domain}"))
  end

  def display_official_position_badge?
    return true if official_level > 1
    official_position_badge? && official_level == 1
  end

  def block
    debates_ids = Debate.where(author_id: id).pluck(:id)
    comments_ids = Comment.where(user_id: id).pluck(:id)
    proposal_ids = Proposal.where(author_id: id).pluck(:id)
    investment_ids = Budget::Investment.where(author_id: id).pluck(:id)
    proposal_notification_ids = ProposalNotification.where(author_id: id).pluck(:id)

    hide

    Debate.hide_all debates_ids
    Comment.hide_all comments_ids
    Proposal.hide_all proposal_ids
    Budget::Investment.hide_all investment_ids
    ProposalNotification.hide_all proposal_notification_ids
  end

  def erase(erase_reason = nil)
    update(
      erased_at: Time.current,
      erase_reason: erase_reason,
      username: nil,
      email: nil,
      unconfirmed_email: nil,
      phone_number: nil,
      encrypted_password: "",
      confirmation_token: nil,
      reset_password_token: nil,
      email_verification_token: nil,
      confirmed_phone: nil,
      unconfirmed_phone: nil
    )
    identities.destroy_all
  end

  def ip_out_of_internal_red?
    return false if Rails.env.test? || Rails.env.development?
    current_ip = IPAddr.new(self.current_sign_in_ip)
    low = IPAddr.new("10.90.0.0")
    high = IPAddr.new("10.90.255.255")
    ip_eq= false
    (low..high).each do |ip|
      if ip.to_s==current_ip.to_s
        ip_eq = true
        break
      end
    end
    ip_eq = true if "127.0.0.1"==current_ip.to_s
    
    !ip_eq
  end

  def phone_number_present?
    !self.try(:phone_number).blank? # && !self.try(:confirmed_phone).blank?  && (self.phone_number == self.confirmed_phone)
  end

  def double_verification?
    return true if !self.ip_out_of_internal_red? && self.administrator? || !self.ip_out_of_internal_red? && self.sures?
    self.ip_out_of_internal_red? && self.try(:administrator?) && self.access_key_inserted_correct? && !required_new_password? && (self.try(:access_key_tried) < 3)
  end

  def verification_in_net?
    !self.ip_out_of_internal_red? && !self.administrator.blank?
  end

  def encrypt_access_key(access_key)
    if !self.blank? && !access_key.blank?
       access_key
    end
  end

  def decrypt_access_key(encrypted_access_key)
      begin
          if !self.blank? && !encrypted_access_key.blank?
             encrypted_access_key.to_s
          end
      rescue
         self.update(access_key_generated_at: nil)
      end
  end

  def access_key_inserted_correct?
    decrypt_access_key(self.access_key_generated.to_s) == decrypt_access_key(self.access_key_inserted.to_s)
  end

  def required_new_password?
    if self.access_key_generated_at.present?
      date1= Time.zone.now
      date2= self.access_key_generated_at
      monts_verifiqued = Setting.find_by(key: "months_to_double_verification").try(:value).blank? ? 3 : Setting.find_by(key: "months_to_double_verification").try(:value).to_i

      ((date2.to_time - date1.to_time)/1.month.second).to_i.abs > monts_verifiqued
    else
      true
    end
  end

  def erased?
    erased_at.present?
  end

  def take_votes_if_erased_document(document_number, document_type)
    erased_user = User.erased.where(document_number: document_number)
                             .where(document_type: document_type).first
    if erased_user.present?
      take_votes_from(erased_user)
      erased_user.update(document_number: nil, document_type: nil)
    end
  end

  def take_votes_from(other_user)
    return if other_user.blank?
    Poll::Voter.where(user_id: other_user.id).update_all(user_id: id)
    Budget::Ballot.where(user_id: other_user.id).update_all(user_id: id)
    Vote.where("voter_id = ? AND voter_type = ?", other_user.id, "User").update_all(voter_id: id)
    data_log = "id: #{other_user.id} - #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}"
    update(former_users_data_log: "#{former_users_data_log} | #{data_log}")
  end

  def locked?
    Lock.find_or_create_by(user: self).locked?
  end

  def self.search(term)
    term.present? ? where("email = ? OR username ILIKE ?", term, "%#{term}%") : none
  end

  def self.username_max_length
    @@username_max_length ||= columns.find { |c| c.name == "username" }.limit || 60
  end

  def self.minimum_required_age
    (Setting["min_age_to_participate"] || 16).to_i
  end

  def show_welcome_screen?
    verification = Setting["feature.user.skip_verification"].present? ? true : unverified?
    sign_in_count == 1 && verification && !organization && !administrator?
  end

  def password_required?
    return false if skip_password_validation
    super
  end

  def username_required?
    !organization? && !erased?
  end

  def email_required?
    !erased? && unverified?
  end

  def locale
    self[:locale] ||= :es.to_s
  end

  def confirmation_required?
    super && !registering_with_oauth
  end

  def send_oauth_confirmation_instructions
    if oauth_email != email
      update(confirmed_at: nil)
      send_confirmation_instructions
    end
    update(oauth_email: nil) if oauth_email.present?
  end

  def name_and_email
    "#{name} (#{email})"
  end

  def age
    Age.in_years(date_of_birth)
  end

  def save_requiring_finish_signup
    begin
      self.registering_with_oauth = true
      save(validate: false)
    # Devise puts unique constraints for the email the db, so we must detect & handle that
    rescue ActiveRecord::RecordNotUnique
      self.email = nil
      save(validate: false)
    end
    true
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def get_or_create_nvote(poll, officer_assignment = nil)
    nvote = Poll::Nvote.new(poll: poll,
                            user: self,
                            officer_assignment: officer_assignment)

    if Poll::Nvote.find_by(voter_hash: nvote.generate_message)
      nvote
    else
      nvote.save
      nvote
    end
  end

  def public_proposals
    public_activity? ? proposals : User.none
  end

  def public_debates
    public_activity? ? debates : User.none
  end

  def public_comments
    public_activity? ? comments : User.none
  end

  # overwritting of Devise method to allow login using email OR username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions.to_hash).where(["lower(email) = ?", login.downcase]).first ||
    where(conditions.to_hash).where(["username = ?", login]).first
  end

  def self.find_by_manager_login(manager_login)
    find_by(id: manager_login.split("_").last)
  end

  def interests
    followables = follows.map(&:followable)
    followables.compact.map { |followable| followable.tags.map(&:name) }.flatten.compact.uniq
  end

  def send_devise_notification(notification, *args)
    begin
      devise_mailer.send(notification, self, *args).deliver_now!
    rescue => e
      begin
        Rails.logger.error("ERROR-MAILER: #{e}")
      rescue
      end
    end
  end

  def exceeded_failed_login_attempts?
    failed_attempts >= Setting["captcha.max_failed_login_attempts"].to_i
  end  

  private

    def clean_document_number
      return unless document_number.present?
      self.document_number = document_number.gsub(/[^a-z0-9]+/i, "").upcase
    end

    def validate_username_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :username,
        maximum: User.username_max_length)
      validator.validate(self)
    end

end
