require 'spec_helper'

describe "Merged" do

  let( :merged ) { BranchSweeper::Merged.new('repository', 'master', 'production,master')}
  let( :current_time ) { Time.now }

  let( :mock_master ) { double('Branch', name: 'master') }
  let( :mock_branch ) { double('Branch', name: 'donkey') }

  let( :commit_message ) { "did work" }
  let( :committer ) { double('Committer', name: "Bob", date: current_time) }
  let( :commit_status ) { double('Status', status: status, base_commit: base_commit) }

  let( :base_commit ) { }
  let( :mock_commit ) {
    double('Commit', commit: double('Commit', commit: double('Commit',
                                                             committer: committer,
                                                             message: commit_message
                                                             )))
  }

  it "should initialize with the current attr_accessors" do
    expect(merged.repository).to eq('repository')
    expect(merged.target_branch).to eq('master')
    expect(merged.exclude_branches).to eq(%w(production master))
  end

  it "should look up the github branches" do
    expect(BranchSweeper.github).to receive(:branches).and_return([])
    merged.run!
  end

  it "should not lookup compare details if a excluded branch is checked" do
    expect(BranchSweeper.github).to receive(:branches).and_return([mock_master])
    expect(BranchSweeper.github).to_not receive(:compare)

    merged.run!
  end

  describe "with branch behind target branch" do
    let(:status) { 'behind' }
    let(:base_commit) { double("Commit", commit: double('Commit', committer: committer, message: commit_message) ) }
    let(:delete_prompt) { "Do you want to delete the branch #{mock_branch.name.colorize(:red)} ?" }
    let(:outdated_msg) { "On #{current_time.to_s.colorize(:blue)}, #{committer.name.colorize(:red)} created #{mock_branch.name.colorize(:red)} with commit message #{commit_message.colorize(:yellow)}\n" }

    before(:each) do
      expect(BranchSweeper.github).to receive(:branches).and_return([mock_branch])
      expect(BranchSweeper.github).to receive(:compare).with('repository', 'master', 'donkey').and_return(commit_status)
      expect(BranchSweeper.github).to receive(:compare).with('repository', 'donkey', 'master').and_return(commit_status)
    end

    it "should not output message to screen" do
      allow(merged).to receive(:confirm_delete)
      expect { merged.run! }.to output(outdated_msg).to_stdout
    end
  end

  describe "with ahead of target branch" do
    let(:status) { 'ahead' }

    before(:each) do
      expect(BranchSweeper.github).to receive(:branches).and_return([mock_branch])
      expect(BranchSweeper.github).to receive(:compare).with('repository', 'master', 'donkey').and_return(commit_status)
    end

    it "should output branch details message" do
      expect { merged.run! }.to_not output.to_stdout
    end

  end

end
