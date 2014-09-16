require "branch_sweeper/version"
require 'octokit'
require 'netrc'

require 'branch_sweeper/inactive'

module BranchSweeper
  def self.github
    @@github ||= Octokit::Client.new(netrc: true)
  end
end
