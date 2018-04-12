class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  has_many :answers #для включения ответов в вопросы
  has_many :attachments

  def short_title
    object.title.truncate(10)
  end
end
