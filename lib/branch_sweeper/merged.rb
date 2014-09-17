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
          # compare the feature/bug branch with target, because it's much faster
          if BranchSweeper.github.compare(repository, target_branch, branch.name).status == 'behind'
            # compare the target with feature/bug branch, to get more details about the feature/bug branch
            commit_details = BranchSweeper.github.compare(repository, branch.name, target_branch).base_commit.commit
            commit_message = commit_details.message.split.join(' ')
            committer = commit_details.committer.name
            date = commit_details.committer.date
            puts "On #{date.to_s.colorize(:blue)}, #{committer.colorize(:red)} created #{branch.name.colorize(:red)} with commit message #{commit_message.colorize(:yellow)}\n"
            confirm_delete(branch.name)
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
