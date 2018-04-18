require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commented) }
  it { should belong_to(:user) }
  it do
    should validate_length_of(:body).
        is_at_least(2).
        on(:create)
  end
end