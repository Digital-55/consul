ActsAsVotable::Vote.class_eval do
  include Graphqlable

  belongs_to :signature
  belongs_to :budget_investment, foreign_key: "votable_id", class_name: "Budget::Investment"

  scope :public_for_api, -> do
    where(%{(votes.votable_type = 'Debate' and votes.votable_id in (?)) or
            (votes.votable_type = 'Topic' and votes.votable_id in (?)) or
            (votes.votable_type = 'Proposal' and votes.votable_id in (?)) or
            (votes.votable_type = 'Comment' and votes.votable_id in (?))},
          Debate.public_for_api.pluck(:id),
          Topic.public_for_api.pluck(:id),
          Proposal.public_for_api.pluck(:id),
          Comment.public_for_api.pluck(:id))
  end

  def self.public_columns_for_api
    ["votable_id",
     "votable_type",
     "vote_flag",
     "created_at"]
  end

  def public_for_api?
    return false unless ["Proposal", "Debate", "Comment", "Topic"].include? votable_type
    return false unless votable.present?
    return false if votable.hidden?
    return false if votable_type == "Comment" && (votable.commentable.blank? || votable.commentable.hidden?)
    return false unless votable.public_for_api?
    return true
  end

  def self.for_debates(debates)
    where(votable_type: "Debate", votable_id: debates)
  end

  def self.for_proposals(proposals)
    where(votable_type: "Proposal", votable_id: proposals)
  end

  def self.for_topics(topics)
    where(votable_type: "Topic", votable_id: topics)
  end

  def self.for_legislation_proposals(proposals)
    where(votable_type: "Legislation::Proposal", votable_id: proposals)
  end

  def self.city_wide
    joins(:votable).where("#{votable.table_name}.geozone is null")
  end

  def self.district_wide
    joins(:votable).where("#{votable.table_name}.geozone is not null")
  end

  def self.for_budget_investments(budget_investments=Budget::Investment.all)
    where(votable_type: "Budget::Investment", votable_id: budget_investments)
  end

  def value
    vote_flag
  end

end
