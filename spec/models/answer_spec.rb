require 'rails_helper'

describe Answer do

  context 'validation' do
    it { should validate_presence_of :body }
  end

  context 'association' do
    it { should belong_to :question }
  end

end