module Abilities
  class SuresAdministrator
    include CanCan::Ability

    def initialize(user)
      #merge Abilities::Administrator.new(user)
      can :index, AdministratorTask
      can [:manage], ::Sures::Actuation
      cannot [:index], SignatureSheet
      cannot [:index], Proposal
    end
  end
end
