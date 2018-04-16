shared_examples_for "rated" do
  let(:another_user) { create(:user) }
  let(:association_of_another_user) { create(object_name, user: another_user) }

  describe 'POST #create_vote' do
    context 'non-author tries to vote' do
      sign_in_user
      context 'non-author did not vote before' do
        it 'saves new vote' do
          expect { post :vote_up, params: { id: resource.id, plus: true }}.to change(resource.votes, :count).by (1)
        end
        it 'responces 200 status' do
          post :vote_up, params: { id: resource.id, plus: true }
          expect(response).to have_http_status 200
        end
      end
      context 'non-author voted before' do
        before {  post :create_vote, params: { id: resource.id, plus: true } }
        it 'doesn`t save new vote' do
          expect { post :create_vote, params: { id: resource.id }}.to_not change(resource.votes, :count)
        end
        it 'responses 403 status' do
          post :create_vote, params: { id: resource.id }
          expect(response). to have_http_status 403
        end
        it 'renders error' do
          post :create_vote, params: { id: resource.id }
          expect(response.body).to have_content 'You are not able to vote'
        end
      end
    end

    context 'author tries to vote' do
      before { sign_in resource.user }
      it 'doesn`t save new vote' do
        expect { post :vote_up, params: { id: resource.id }}.to_not change(resource.votes, :count)
      end
      it 'responses 403 status' do
        post :vote_up, params: { id: resource.id }
        expect(response).to have_http_status 403
      end
      it 'renders error' do
        post :vote_up, params: { id: resource.id }
        expect(response.body).to have_content 'You are not able to vote'
      end
    end
  end

  describe 'DELETE #destroy_vote' do
    context 'non-author tries to cancel' do
      sign_in_user
      context 'non-author did not vote before' do
        it 'doesn`t delete vote' do
          expect { delete :cancel_vote, params: { id: resource.id}}.to_not change(resource.votes, :count)
        end
        it 'responces 403 status' do
          delete :vote_down, params: { id: resource.id}
          expect(response). to have_http_status 403
        end
        it 'renders error' do
          delete :vote_down, params: { id: resource.id }
          expect(response.body).to have_content 'Can`t cancel vote'
        end
      end

      context 'non-author voted before' do
        before {  post :vote_up, params: { id: resource.id } }
        it 'deletes vote' do
          expect { delete :vote_down, params: { id: resource.id }}.to change(resource.votes, :count).by(-1)
        end
        it 'responses 200 status' do
          delete :vote_down, params: { id: resource.id }
          expect(response). to have_http_status 200
        end
      end
    end
  end

  describe 'POST #vote_reset' do
    sign_in_user
    it 'cant reset vote item' do
      post :vote_down, params: { id: association_of_another_user }
      post :vote_reset, params: { id: association_of_another_user }
      expect(association_of_another_user.vote_score).to eq 0
      context 'author tries to cancel vote' do
        before { sign_in resource.user }
        it 'doesn`t delete vote' do
          expect { delete :cancel_vote, params: { id: resource.id }}.to_not change(resource.votes, :count)
        end
        it 'responses 403 status' do
          delete :cancel_vote, params: { id: resource.id }
          expect(response). to have_http_status 403
        end
        it 'renders error' do
          delete :cancel_vote, params: { id: resource.id }
          expect(response.body).to have_content 'Can`t cancel vote'
        end
      end
    end
  end
end