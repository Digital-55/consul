class Poll::Question < ApplicationRecord
  include Measurable
  include Searchable

  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  translates :title, touch: true
  include Globalizable

  belongs_to :poll
  belongs_to :author, -> { with_hidden }, class_name: "User", foreign_key: "author_id"

  has_many :comments, as: :commentable
  has_many :answers, class_name: "Poll::Answer"
  has_many :question_answers, -> { order "given_order asc" }, class_name: "Poll::Question::Answer", dependent: :destroy
  has_many :partial_results
  belongs_to :proposal

  accepts_nested_attributes_for :question_answers, reject_if: :all_blank, allow_destroy: true

  validates_translation :title, presence: true, length: { minimum: 4 }
  validates :author, presence: true
  # validates :poll_id, presence: true

  scope :by_poll_id,    ->(poll_id) { where(poll_id: poll_id) }

  scope :sort_for_list, -> { order("poll_questions.proposal_id IS NULL", :created_at)}
  scope :for_render,    -> { includes(:author, :proposal) }

  def self.search(params)
    results = all
    results = results.by_poll_id(params[:poll_id]) if params[:poll_id].present?
    results = results.pg_search(params[:search])   if params[:search].present?
    results
  end

  def searchable_values
    { title                 => "A",
      proposal.try(:title)  => "A",
      author.username       => "C",
      author_visible_name   => "C" }
  end

  def copy_attributes_from_proposal(proposal)
    if proposal.present?
      self.author = proposal.author
      self.author_visible_name = proposal.author.name
      self.proposal_id = proposal.id
      send(:"#{localized_attr_name_for(:title, Globalize.locale)}=", proposal.title)
    end
  end

  delegate :answerable_by?, to: :poll

  def self.answerable_by(user)
    return none if user.nil? || user.unverified?
    where(poll_id: Poll.answerable_by(user).pluck(:id))
  end

  def answers_total_votes
    question_answers.inject(0) { |total, question_answer| total + question_answer.total_votes }
  end

  def most_voted_answer_id
    question_answers.max_by {|answer| answer.total_votes }&.id
  end

  def self.translate_column_names
    [:title ]
  end
end
