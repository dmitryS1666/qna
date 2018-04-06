class AnswersController < ApplicationController
  include Voted
  include Comentabled

  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:destroy, :update, :make_best]
  after_action :publish_answer, only: :create
  before_action :load_answer, only: :update

  respond_to :js
  respond_to :json, only: :create

  def create
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

  def set_answer
    @answer = Answer.find(params[:id])
  end

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

  def set_question
    @question = Question.find(params[:question_id])
  end

end