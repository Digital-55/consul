module Abilities
  class ComplanEditor
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Administrator.new(user)
      can :manage, Complan::Project
      can :manage, Complan::Performance
      can :manage, Complan::Center
      can :manage, Complan::Financing
      can :manage, Complan::Strategy
      can :manage, Complan::Typology
      can :manage, Complan::ThecnicalTable
    end
  end
end
