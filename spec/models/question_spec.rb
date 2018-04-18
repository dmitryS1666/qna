require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body}
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:attachments)}
  it { should have_many(:ratings)}
  it { should have_many(:comments)}
  it { should have_many(:subscriptions)}
  it { should have_many(:subscribers)}

  it { should accept_nested_attributes_for :attachments}

  it do
    should validate_length_of(:title).
        is_at_least(10).
        on(:create)
  end
  it do
    should validate_length_of(:body).
        is_at_least(2).
        on(:create)
  end

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create :question, user: user }

  describe '#subscribed?' do
    it 'user can subscribe?' do
      expect(question).to be_subscribed(user)
    end
  end

  describe '#add_subscribe' do
    it 'create a new subscribe for question' do
      expect(question.subscriptions).to_not include(other_user)
      question.add_subscribe(other_user)
      expect(question.subscriptions.first.user_id).to eq question.user.id
    end
  end

  describe '#del_subscribe' do
    it 'del subscribe for question' do
      question.add_subscribe(other_user)
      expect(question.subscriptions.first.user_id).to eq question.user.id
      question.del_subscribe(other_user)
      expect(question.subscriptions.first.user_id).to_not eq question.user.id
    end
  end

  let!(:object_name) { :question }
  it_behaves_like "model_rated"
end