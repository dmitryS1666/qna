shared_examples_for "rated" do
  let(:another_user) { create(:user) }
  let(:association_of_another_user) { create(object_name, user: another_user) }

  describe 'POST #vote_up' do
    sign_in_user
    let(:my_item) { create(object_name, user: @user) }
    it "vote_up for foreign item" do
      post :vote_up, params: { id: association_of_another_user }
      expect(association_of_another_user.vote_score).to eq 1
    end

    it 'cant vote_up double for foreign item' do
      post :vote_up, params: { id: association_of_another_user }
      post :vote_up, params: { id: association_of_another_user }
      expect(response).to have_http_status(403)
    end

    it 'cant vote_up for his item' do
      post :vote_up, params: { id: my_item }
      expect(my_item.vote_score).to eq 0
    end
  end

  describe 'POST #vote_down' do
    sign_in_user
    let(:my_item) { create(object_name, user: @user) }
    it 'vote_down for foreign item' do
      post :vote_down, params: { id: association_of_another_user }
      expect(association_of_another_user.vote_score).to eq -1
    end

    it 'cant vote_down double for foreign item' do
      post :vote_down, params: { id: association_of_another_user }
      post :vote_down, params: { id: association_of_another_user }
      expect(response).to have_http_status(403)
    end

    it 'cant vote_down for his item' do
      post :vote_down, params: { id: my_item }
      expect(my_item.vote_score).to eq 0
    end
  end

  describe 'POST #vote_reset' do
    sign_in_user
    it 'cant reset vote item' do
      post :vote_down, params: { id: association_of_another_user }
      post :vote_reset, params: { id: association_of_another_user }
      expect(association_of_another_user.vote_score).to eq 0
    end
  end
end