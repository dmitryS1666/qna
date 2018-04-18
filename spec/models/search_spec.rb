require 'rails_helper'

RSpec.describe Search do
  describe '.find' do
    %w(Questions Answers Comments Users).each do |attr|
      it "gets param: #{attr}" do
        expect(attr.singularize.classify.constantize).to receive(:search).with('what you need find')
        Search.find('what you need find', attr)
      end
    end

    %w(Everywhere '').each do |attr|
      it "gets param: #{attr}" do
        expect(ThinkingSphinx).to receive(:search).with('what you need find')
        Search.find('what you need find', attr)
      end
    end
  end
end