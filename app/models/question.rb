class Question < ApplicationRecord
  include Voted
  include Commented

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10 }
  validates :body, presence: true, length: { minimum: 2 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_owner

  def add_subscribe(user)
    subscriptions.create!(user: user)
  end

  def del_subscribe(user)
    subscriptions.where(user: user).destroy_all
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  private

  def subscribe_owner
    Subscription.create!(user: user, question: self)
  end
end