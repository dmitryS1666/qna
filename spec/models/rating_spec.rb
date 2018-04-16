require 'rails_helper'

RSpec.describe Rating, type: :model do
  it do
    should validate_inclusion_of(:vote).in_array([-1, 0, 1])
  end
  it { should belong_to(:appraised) }
  it { should belong_to(:user) }
end