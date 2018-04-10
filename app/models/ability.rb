class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Attachment]
    can :comment, [Question, Answer]

    alias_action :update, :destroy, to: :subject_pull
    can :subject_pull, [Question, Answer] do |type|
      user.owner_of?(type)
    end

    can :best_answer, Answer do |answer|
      user.owner_of?(answer.question) && !answer.best?
    end

    alias_action :vote_up, :vote_down, to: :vote_pull
    can :vote_pull, [Question, Answer] do |type|
      !user.owner_of?(type)
    end

    can :vote_reset, Vote do |vote|
      user.owner_of?(vote)
    end
  end
end