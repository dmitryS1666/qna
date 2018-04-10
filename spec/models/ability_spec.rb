require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) {nil}

    it {should be_able_to :read, Question}
    it {should be_able_to :read, Answer}
    it {should be_able_to :read, Comment}

    it {should_not be_able_to :manage, :all}
  end

  describe 'user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, user: user, question: question }
    let(:foreign_answer) { create :answer, user: other, question: question }

    it {should_not be_able_to :manage, :all}
    it {should be_able_to :read, :all}

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Attachment }

    context 'Question' do
      it { should be_able_to :update, question, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should be_able_to :comment, Question }
      it { should_not be_able_to :vote_up, question, user: user }
      it { should_not be_able_to :vote_down, question, user: user }
      it { should_not be_able_to :vote_reset, question, user: user }
    end
    context 'Answer' do
      it { should be_able_to :update, answer, user: user }
      it { should be_able_to :destroy, answer, user: user }
      it { should be_able_to :comment, Answer }
      it { should_not be_able_to :vote_up, answer, user: user }
      it { should_not be_able_to :vote_down, answer, user: user }
      it { should_not be_able_to :vote_reset, answer, user: user }
    end
  end

  describe 'admin' do
    let(:user) { create(:user, admin: true ) }

    it {should be_able_to :manage, :all}
  end

end