class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  # TODO идея понятна с запросом, но не ясно в реализации - записать отдельным методом, получение ответов связанных с вопросом
  has_many :answers
  has_many :attachments

  def short_title
    object.title.truncate(10)
  end
end
