module Abilities
  class ParbudgetReader
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)

      can [:index, :show], Parbudget::Ambit
      cannot [:create_ambit, :update_ambit, :destroy], Parbudget::Ambit

      can [:index, :show], Parbudget::Center
      cannot [:new, :edit, :create, :update, :destroy], Parbudget::Center

      can [:index, :show], Parbudget::Project
      cannot [:new, :edit, :create, :update, :destroy], Parbudget::Project

      can [:index, :show], Parbudget::Meeting
      cannot [:new, :edit, :create, :update, :destroy], Parbudget::Meeting

      can [:index], Parbudget::Topic
      cannot [:generate_topic, :update_topic, :destroy], Parbudget::Topic

      can [:index, :show], Parbudget::Responsible
      cannot [:new, :edit, :create, :update, :destroy], Parbudget::Responsible

    end
  end
end
