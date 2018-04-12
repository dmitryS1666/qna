class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def create
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionSerializer
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end