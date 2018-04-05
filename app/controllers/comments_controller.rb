class CommentsController < ApplicationController
  include Contexted

  before_action :set_context, only: [:create]

  after_action :publish_comment, only: [:create]

  def create
    authorize Comment
    @comment = @context.comments.create(
        comment_params.merge(user: current_user)
    )
    render_json @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
        "questions/#{@answer.question_id}/answers", @answer
    )
  end
end