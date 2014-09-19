require 'spec_helper'

describe "Inactive" do

  let( :inactive ) { BranchSweeper::Inactive.new('repository', '365', 'production,master')}
  let( :current_time ) { Time.now }
  let( :past_time ) { Time.now - (60*60*24*730) }

  let( :mock_master ) { double('Branch', name: 'master') }
  let( :mock_branch ) { double('Branch', name: 'donkey') }

  let( :commit_message ) { "did work" }

  let( :mock_commit ) {
    double('Commit', commit: double('Commit', commit: double('Commit',
                                                             committer: committer,
                                                             message: commit_message
                                                             )))
  }

  it "should initialize with the current attr_accessors" do
    expect(inactive.repository).to eq('repository')
    expect(inactive.inactive_days).to eq(365)
    expect(inactive.exclude_branches).to eq(%w(production master))
  end

  it "should look up the github branches" do
    expect(BranchSweeper.github).to receive(:branches).and_return([])
    inactive.run!
  end

  it "should not lookup branch details if a excluded branch is checked" do
    expect(BranchSweeper.github).to receive(:branches).and_return([mock_master])
    expect(BranchSweeper.github).to_not receive(:branch)

    inactive.run!
  end


  describe "with current branches" do
    let( :committer ) { double('Committer', name: "Bob", date: current_time) }

    before(:each) do
      expect(BranchSweeper.github).to receive(:branches).and_return([mock_branch])
      expect(BranchSweeper.github).to receive(:branch).with('repository', 'donkey').and_return(mock_commit)
    end

    it "should not output message to screen" do
      expect { inactive.run! }.to_not output.to_stdout
    end
  end

  describe "with outdated branches" do
    let( :committer ) { double('Committer', name: "Bob", date: past_time) }
    let( :outdated_msg ) { "On #{past_time.to_s.colorize(:blue)}, #{committer.name.colorize(:red)} created #{mock_branch.name.colorize(:red)} with commit message #{commit_message.colorize(:yellow)}\n" }
    let( :delete_prompt ) { "Do you want to delete the branch #{mock_branch.name.colorize(:red)} ?" }

    before(:each) do
      expect(BranchSweeper.github).to receive(:branches).and_return([mock_branch])
      expect(BranchSweeper.github).to receive(:branch).with('repository', 'donkey').and_return(mock_commit)
    end

    it "should output branch details message" do
      allow(inactive).to receive(:confirm_delete)
      expect { inactive.run! }.to output(outdated_msg).to_stdout
    end

  end

end
