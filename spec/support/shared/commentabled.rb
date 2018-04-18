shared_examples_for "commentabled" do
  describe 'POST #comment' do
    sign_in_user
    let!(:association) { create(object_name) }
    let(:comment) { attributes_for(:comment) }

    it 'adding commet' do
      expect { post :comment, params: { id: association, comment: comment }, format: :js }.to change(Comment, :count).by(1)
    end
  end
end