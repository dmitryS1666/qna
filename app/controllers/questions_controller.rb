class QuestionsController < ApplicationController
  include Voted
  include Comentabled

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update]
  after_action :publish_question, only: [:create]
  before_action :build_answer, only: :show

  respond_to :html

  def index
    respond_with(@questions = Question.all)
  end

  def new
    @question = Question.new
    respond_with(@question.attachments.build)
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
      respond_with(@question.destroy) if current_user.owner_of?(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/question',
            locals: { question: @question }
        )
    )
  end

  def find_question
    @question = Question.find(params[:id])
  end

end