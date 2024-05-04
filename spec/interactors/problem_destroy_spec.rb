describe ProblemDestroy do
  let(:problem_destroy) do
    ProblemDestroy.new(problem)
  end

  context "in unit way" do
    let(:problem) do
      problem = Problem.new
      allow(problem).to receive(:errs).and_return(double(:criteria, only: [err1, err2]))
      allow(problem).to receive(:comments).and_return(double(:criteria, only: [comment1, comment2]))
      allow(problem).to receive(:delete)
      problem
    end
    let(:err1) { Err.new }
    let(:err2) { Err.new }

    let(:comment1) { Comment.new }
    let(:comment2) { Comment.new }

    describe "#initialize" do
      it 'take a problem like args' do
        expect(problem_destroy.problem).to eq problem
      end
    end

    describe "#execute" do
      it 'destroy the problem himself' do
        expect(problem).to receive(:delete).and_return(true)
        problem_destroy.execute
      end

      it 'delete all errs associate' do
        expect(Err).to receive(:delete_all).with(_id: { '$in' => [err1.id, err2.id] })
        problem_destroy.execute
      end

      it 'delete all comments associate' do
        expect(Comment).to receive(:delete_all).with(_id: { '$in' => [comment1.id, comment2.id] })
        problem_destroy.execute
      end

      it 'delete all notice of associate to this errs' do
        expect(Notice).to receive(:delete_all).with(err_id: { '$in' => [err1.id, err2.id] })
        problem_destroy.execute
      end
    end
  end

  context "in integration way" do
    let!(:problem) { Fabricate(:problem) }
    let!(:comment1) { Fabricate(:comment, err: problem) }
    let!(:comment2) { Fabricate(:comment, err: problem) }
    let!(:err1) { Fabricate(:err, problem:) }
    let!(:err2) { Fabricate(:err, problem:) }
    let!(:notice11) { Fabricate(:notice, err: err1) }
    let!(:notice12) { Fabricate(:notice, err: err1) }
    let!(:notice21) { Fabricate(:notice, err: err2) }
    let!(:notice22) { Fabricate(:notice, err: err2) }

    it 'should all destroy' do
      problem_destroy.execute
      expect(Problem.where(_id: problem.id).entries).to be_empty
      expect(Err.where(_id: err1.id).entries).to be_empty
      expect(Err.where(_id: err2.id).entries).to be_empty
      expect(Comment.where(_id: comment1.id).entries).to be_empty
      expect(Comment.where(_id: comment2.id).entries).to be_empty
      expect(Notice.where(_id: notice11.id).entries).to be_empty
      expect(Notice.where(_id: notice12.id).entries).to be_empty
      expect(Notice.where(_id: notice21.id).entries).to be_empty
      expect(Notice.where(_id: notice22.id).entries).to be_empty
    end
  end
end
