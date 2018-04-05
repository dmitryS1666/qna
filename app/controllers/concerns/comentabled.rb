module Comentabled
  extend ActiveSupport::Concern

  def comment
    @item = controller_name.classify.constantize.find(params[:id])

    if @item.class.name == 'Question'
      @question_id = @item.id
    elsif @item.class.name == 'Answer'
      @question_id = @item.question.id
    end

    @comment = @item.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    return if @comment.errors.any?
    ActionCable.server.broadcast("comments_for_question_#{@question_id}", comment: @comment)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end