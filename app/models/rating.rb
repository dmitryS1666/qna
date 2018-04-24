class Rating < ApplicationRecord
  belongs_to :appraised, polymorphic: true
  belongs_to :user

  validates :vote, inclusion: [-1, 0, 1]
end