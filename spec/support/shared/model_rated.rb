shared_examples_for "model_rated" do
  let(:user) { create(:user) }
  let(:assosiation) { create(object_name, user: user) }

  describe '#vote_score' do
    it 'get vote sum score' do
      assosiation.vote_up(user)
      expect(assosiation.vote_score).to eq 1
    end
  end
  describe '#vote_up' do
    it 'add a new positive rating' do
      expect(assosiation.ratings).to include(assosiation.vote_up(user))
    end

    it 'check assosiation new positive rating with user' do
      expect(user.ratings).to include(assosiation.vote_up(user))
    end

    it 'changes vote score by 1' do
      rate = assosiation.vote_up(user)
      expect(assosiation.vote_score).to eq 1
    end
  end

  describe '#vote_down' do
    it 'add a new negative rating' do
      expect(assosiation.ratings).to include(assosiation.vote_down(user))
    end

    it 'check assosiation new negative rating with user' do
      expect(user.ratings).to include(assosiation.vote_down(user))
    end

    it 'changes vote score by -1' do
      rate = assosiation.vote_down(user)
      expect(assosiation.vote_score).to eq -1
    end
  end

  describe '#voted?' do
    it 'user can vote' do
      assosiation.vote_down(user)
      expect(assosiation).to be_voted(user)
    end

    it 'user cant vote' do
      expect(assosiation).not_to be_voted(user)
    end
  end

  describe '#vote_reset' do
    it 'Reset votes' do
      assosiation.vote_up(user)
      assosiation.vote_reset(user)
      expect(assosiation.vote_score).to eq 0
    end
  end
end