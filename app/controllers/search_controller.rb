class SearchController < ApplicationController

  def search
    @query = params[:query]
    @category = params[:category]
    @result = Search.find(@query, @category) if @query.present?
  end

end
