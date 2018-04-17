class Question < ApplicationRecord
  include Voted
  include Commented

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10 }
  validates :body, presence: true, length: { minimum: 2 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_owner

  scope :last_day, -> { where(created_at: 24.hours.ago..Time.now) }

  def add_subscribe(user)
    subscriptions.create!(subscriber: user)
  end

  def del_subscribe(user)
    subscriptions.where(subscriber: user).destroy_all
  end

  def subscribed?(user)
    subscriptions.exists?(subscriber: user)
  end

  private

  def subscribe_owner
    subscriptions.create!(subscriber: user, question: self)
  end
end