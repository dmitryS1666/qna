class Question < ApplicationRecord
  include Voted
  include Commented

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10 }
  validates :body, presence: true, length: { minimum: 2 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end