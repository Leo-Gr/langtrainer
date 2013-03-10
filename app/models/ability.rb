class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, Exercise
      can [:show, :edit, :update, :destroy], Sentence
      can :create, Sentence, sentence_id: nil, type: nil
    elsif user.has_role? :member
      can [:show, :edit, :update, :destroy], Exercise, user_id: user.id
      if user.exercises.count < User::EXERCISES_MAX
        can :create, Exercise
      end
      can [:show, :edit, :update, :destroy], Sentence, user_id: user.id, type: nil
      if user.sentences.count < Sentence::MAX
        can :create, Sentence, sentence_id: nil, type: nil
      end
      can [:update, :destroy], Correction, user_id: user.id
      can :create, Correction, sentence: { owner: nil }
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
