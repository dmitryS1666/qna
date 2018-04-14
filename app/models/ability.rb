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
      user.author?(type)
    end

    can :best_answer, Answer do |answer|
      user.author?(answer.question) && !answer.best?
    end

    alias_action :create_vote, :delete_vote, to: :vote_pull
    can :vote_pull, [Question, Answer] do |type|
      !user.author?(type)
    end

    can :cancel_vote, Vote do |vote|
      user.author?(vote)
    end
  end
end