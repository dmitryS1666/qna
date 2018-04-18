module Comentabled
  extend ActiveSupport::Concern

  included do
    before_action :find_item, only: :comment
    before_action :recognize_path, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @item.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast("comments_for_question_#{@question_id}", comment: @comment)
  end

  def find_item
    @item = controller_name.classify.constantize.find(params[:id])
  end

  def recognize_path
    if @item.class.name == 'Question'
      @question_id = @item.id
    elsif @item.class.name == 'Answer'
      @question_id = @item.question.id
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end