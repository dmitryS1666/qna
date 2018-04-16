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
    let(:foreign_question) { create :question, user: other }
    let(:answer) { create :answer, user: user, question: question }
    let(:other_answer) { create :answer, user: other, question: question }
    let(:vote) { create :vote, user: user, votable: question }
    let(:other_vote) { create :vote, user: other, votable: question }

    it {should_not be_able_to :manage, :all}
    it {should be_able_to :read, :all}

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Attachment }

    context 'Question' do
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, foreign_question, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, foreign_question, user: user }
      it { should be_able_to :comment, Question }
      it { should be_able_to :vote_up, foreign_question, user: user }
      it { should be_able_to :vote_down, foreign_question, user: user }
      it { should be_able_to :vote_reset, foreign_question, user: user }
      it { should_not be_able_to :vote_up, question, user: user }
      it { should_not be_able_to :vote_down, question, user: user }
      it { should_not be_able_to :vote_reset, question, user: user }
    end
    context 'Answer' do
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, other_answer , user: user }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, other_answer , user: user }
      it { should be_able_to :comment, Answer }
      it { should be_able_to :vote_up, other_answer, user: user }
      it { should be_able_to :vote_down, other_answer, user: user }
      it { should be_able_to :vote_reset, other_answer, user: user }
      it { should_not be_able_to :vote_up, answer, user: user }
      it { should_not be_able_to :vote_down, answer, user: user }
      it { should_not be_able_to :vote_reset, answer, user: user }
      it { should be_able_to :best_answer, other_answer, user: user }
      it { should_not be_able_to :best_answer, create(:answer, user: other, question: foreign_question), user: user }
    end
  end

  describe 'admin' do
    let(:user) { create(:user, admin: true ) }

    it {should be_able_to :manage, :all}
  end

end