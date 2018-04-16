class Answer < ApplicationRecord
  include Voted
  include Commented
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 2 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :sort_by_best, -> { order(best: :desc) }

  def flag_as_best
    return if reload.best?

    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end