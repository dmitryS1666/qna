module Voting
  extend ActiveSupport::Concern

  included do
    before_action :load_item, only: %i[vote_reset vote_down vote_up]
    before_action :check_access?, only: %i[vote_down vote_up]
  end

  def vote_reset

    if @item.voted?(current_user)
      @item.vote_reset(current_user)
      render json: { rating: @item.vote_score }
    else
      head :forbidden
    end
  end

  def vote_up
    @item.vote_up(current_user)
    render json: { rating: @item.vote_score }
  end

  def vote_down
    @item.vote_down(current_user)
    render json: { rating: @item.vote_score }
  end

  private

  def check_access?
    if current_user.owner_of?(@item) || @item.voted?(current_user)
      head :forbidden
    end
  end

  def load_item
    @item = controller_name.classify.constantize.find(params[:id])
    puts "@item"
  end
end