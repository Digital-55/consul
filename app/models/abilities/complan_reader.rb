module Abilities
  class Complan::Reader
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)

      can [:index, :show], Complan::Ambit
      cannot [:create_ambit, :update_ambit, :destroy], Complan::Ambit

      can [:index, :show], Complan::Center
      cannot [:new, :edit, :create, :update, :destroy], Complan::Center

      can [:index, :show], Complan::Project
      cannot [:new, :edit, :create, :update, :destroy], Complan::Project

      can [:index, :show], Complan::Meeting
      cannot [:new, :edit, :create, :update, :destroy], Complan::Meeting

      can [:index], Complan::Topic
      cannot [:generate_topic, :update_topic, :destroy], Complan::Topic

      can [:index, :show], Complan::Responsible
      cannot [:new, :edit, :create, :update, :destroy], Complan::Responsible

    end
  end
end
