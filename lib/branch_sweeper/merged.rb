require 'highline/import'
require 'methadone'
require 'octokit'
require 'netrc'
require 'time'
require 'colorize'

module BranchSweeper
  class Merged

    include Methadone::CLILogging
    include Methadone::SH
    include Methadone::ExitNow

    attr_reader :repository, :target_branch, :exclude_branches

    def initialize(repository, target_branch, exclude_branches)
      @repository = repository
      @target_branch = target_branch
      @exclude_branches = exclude_branches.split(",")
    end

    def run!
      branches = BranchSweeper.github.branches(repository)

      branches.each do |branch|
        unless exclude_branches.include?(branch.name)
          if BranchSweeper.github.compare(repository, target_branch, branch.name)[:ahead_by] > 0
            puts branch.name.colorize(:red)
          else
            puts branch.name.colorize(:yellow)
          end
        end
      end
    end

    private

    def confirm_delete(branch)
      if agree("Do you want to delete the branch #{branch.colorize(:red)} ?")
        info "Deleting the branch " << branch.colorize(:blue)
        BranchSweeper.github.delete_branch(repository, branch)
      end
    end
  end
end
