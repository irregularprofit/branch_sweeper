require 'spec_helper'

describe "BranchSweeper" do

  it "get stuff done" do
    expect { BranchSweeper.github }.to_not raise_error
  end

end
