class AnswersController < ApplicationController
  include Voted
  include Comentabled

  before_action :authenticate_user!
  before_action :load_answer, only: %i[destroy update best_answer]
  before_action :load_question, only: %i[update destroy best_answer]
  after_action :publish_answer, only: %i[create]

  respond_to :js, only: %i[create destroy update]
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_with(@answer.save)
  end

  def update
    respond_with(@answer.update(answer_params)) if current_user.author?(@answer)
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author?(@answer)
  end

  def make_best
    @answer.make_best! if current_user.author?(@answer.question)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "questions/#{@answer.question_id}/answers", @answer
    )
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = @answer.question
  end

end