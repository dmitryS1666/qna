class Comment < ApplicationRecord
  belongs_to :commented, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }
end
