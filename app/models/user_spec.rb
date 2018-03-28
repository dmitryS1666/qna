require 'rails_helper'

RSpec.describe User do
  it { should validate_presense_of :email }
  it { should validate_presense_of :password }
end