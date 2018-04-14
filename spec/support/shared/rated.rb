shared_examples_for "rated" do
  let!(:user) { create :user }
  let!(:resource) { create(object_name, user: user) }

  describe 'POST #create_vote' do
    context 'non-author tries to vote' do
      before { sign_in user }
      context 'non-author did not vote before' do
        it 'saves new vote' do
          expect { post :create_vote, params: { id: resource.id, plus: true }}.to change(resource.votes, :count).by (1)
        end
        it 'responces 200 status' do
          post :create_vote, params: { id: resource.id, plus: true }
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
      before { sign_in user }
      it 'doesn`t save new vote' do
        expect { post :create_vote, params: { id: resource.id }}.to_not change(resource.votes, :count)
      end
      it 'responses 403 status' do
        post :create_vote, params: { id: resource.id }
        expect(response).to have_http_status 403
      end
      it 'renders error' do
        post :create_vote, params: { id: resource.id }
        expect(response.body).to have_content 'You are not able to vote'
      end
    end
  end

  describe 'DELETE #destroy_vote' do
    context 'non-author tries to cancel' do
      sign_in_user
      context 'non-author did not vote before' do
        it 'doesn`t delete vote' do
          expect { delete :delete_vote, params: { id: resource.id}}.to_not change(resource.votes, :count)
        end
        it 'responces 403 status' do
          delete :delete_vote, params: { id: resource.id}
          expect(response). to have_http_status 403
        end
        it 'renders error' do
          delete :delete_vote, params: { id: resource.id }
          expect(response.body).to have_content 'Can`t cancel vote'
        end
      end

      context 'non-author voted before' do
        before {  post :create_vote, params: { id: resource.id } }
        it 'deletes vote' do
          expect { delete :delete_vote, params: { id: resource.id }}.to change(resource.votes, :count).by(-1)
        end
        it 'responses 200 status' do
          delete :delete_vote, params: { id: resource.id }
          expect(response). to have_http_status 200
        end
      end
    end

    context 'author tries to cancel vote' do
      before { sign_in resource.user }
      it 'doesn`t delete vote' do
        expect { delete :delete_vote, params: { id: resource.id }}.to_not change(resource.votes, :count)
      end
      it 'responses 403 status' do
        delete :delete_vote, params: { id: resource.id }
        expect(response). to have_http_status 403
      end
      it 'renders error' do
        delete :delete_vote, params: { id: resource.id }
        expect(response.body).to have_content 'Can`t cancel vote'
      end
    end
  end
end