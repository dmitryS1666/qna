require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_user) { create(:user) }
  let(:foreign_question) { create(:question, user: another_user) }
  let(:comment) { attributes_for(:comment) }
  let(:subscribe) { create(:subscribe, user: user, question: question)}

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachaments for @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    subject(:create_question) { post :create, params: { question: attributes_for(:question) } }

    context 'with valid attributes' do

      it 'user associated with the question' do
        expect { create_question }.to change(user.questions, :count).by(1)
      end

      it 'saving a question to database' do
        expect { create_question }.to change { Question.count }.by(1)
      end

      it 'redirect to question after saving' do
        create_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not saving a invlaid question to database' do
        expect { post :create, params: { question: attributes_for(:wrong_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:wrong_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'build new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'DELETE #destoy' do
    sign_in_user

    before { question }

    it 'author can delete his question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'user can not delete someone else question' do
      another_user = create(:user)
      foreign_question = create(:question, user: another_user)

      expect { delete :destroy, params: { id: foreign_question } }.to_not change(Question, :count)
    end

    it 'redirect to index of questions' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    subject(:update_question) do
      patch :update, params: {
          id: question, question: attributes_for(:question), format: :js
      }
    end

    it 'assigns the requested question to @question' do
      update_question
      expect(assigns(:question)).to eq question
    end

    it 'change question attributes' do
      patch :update, params: {
          id: question, question: { title: 'new title question for test question', body: 'new body question for test question' }, format: :js
      }

      question.reload
      expect(question.body).to eq 'new body question for test question'
      expect(question.title).to eq 'new title question for test question'
    end

    it "user can not change foreign question" do
      patch :update, params: {
          id: foreign_question, question: { title: 'new title question for test question', body: 'new body question for test question' }, format: :js
      }

      foreign_question.reload
      expect(question.body).to_not eq 'new body question for test question'
      expect(question.title).to_not eq 'new title question for test question'
    end

    it 'render update template' do
      update_question
      expect(response).to render_template :update
    end
  end

  describe 'POST #subscribe' do
    sign_in_user
    subject(:create_subscription) { post :subscribe, params: { id: foreign_question.id, format: :js } }

    it "subscribe for question" do
      expect { create_subscription }.to change(user.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #undescribe' do
    sign_in_user
    subject(:create_subscription) { post :subscribe, params: { id: foreign_question.id, format: :js } }

    it "unsubscribe for sunscribed question" do
      create_subscription

      expect { delete :unsubscribe, params: { id: foreign_question } }.to change(user.subscriptions, :count).by(-1)
    end
  end

  let!(:object_name) { :question }
  it_behaves_like "commentabled"
  it_behaves_like "rated"
end