module Commented
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commented, dependent: :destroy
  end
end