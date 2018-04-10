require 'rails_helper'

describe User do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user) }
  let!(:another_question) { create(:question) }
  let!(:another_answer) { create(:question) }

  context 'association' do
    it { should have_many(:questions).dependent :destroy }
    it { should have_many(:answers).dependent :destroy }
    it { should have_many(:votes).dependent :destroy }
    it { should have_many(:authorizations)}
  end

  context 'validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  context 'User is an author of' do

    context 'question' do
      it 'returns true if user is an author' do
        expect(user).to be_author(question)
      end

      it 'returns false if user is not an author' do
        expect(user).to_not be_author(another_question)
      end
    end

    context 'answer' do
      it 'returns true if user is an author' do
        expect(user).to be_author(answer)
      end

      it 'returns false if user is not an author' do
        expect(user).to_not be_author(another_answer)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'twitter', uid: '123456')

        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: 'test-test@test.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorizations for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorizations with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end