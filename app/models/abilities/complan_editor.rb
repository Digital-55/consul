module Abilities
  class Complan::Editor
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Administrator.new(user)
      can :manage, Complan::Ambit
      can :manage, Complan::Project
      can :manage, Complan::Center
      can :manage, Complan::Meeting
      can :manage, Complan::Topic
      can :manage, Complan::Responsible
    end
  end
end
