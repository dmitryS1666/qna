module Subscribled
  extend ActiveSupport::Concern

  def subscribe
    respond_with(@question.add_subscribe(current_user), template: 'common/subscribe')
  end

  def unsubscribe
    respond_with(@question.del_subscribe(current_user), template: 'common/subscribe')
  end
end