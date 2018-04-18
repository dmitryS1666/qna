class Comment < ApplicationRecord
  belongs_to :commented, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }
end
