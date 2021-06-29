module Abilities
  class ParbudgetEditor
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Administrator.new(user)
      can :manage, Parbudget::Ambit
      can :manage, Parbudget::Project
      can :manage, Parbudget::Center
      can :manage, Parbudget::Meeting
      can :manage, Parbudget::Topic
      can :manage, Parbudget::Responsible
    end
  end
end
