require 'rails_helper'

describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:subscriber) }
end