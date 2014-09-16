require 'highline/import'
require 'methadone'
require 'octokit'
require 'netrc'
require 'time'
require 'colorize'

module BranchSweeper
  class Clean

    include Methadone::CLILogging
    include Methadone::SH
    include Methadone::ExitNow

    attr_reader :repository, :inactive_days, :exclude_branches

    def initialize(repository, inactive_days, exclude_branches)
      @repository = repository
      @inactive_days = inactive_days.to_i
      @exclude_branches = exclude_branches.split(",")
    end

    def run!
      branches = BranchSweeper.github.branches(repository)

      branches.each do |branch|
        unless exclude_branches.include?(branch.name)
          commit = BranchSweeper.github.commit(repository, branch.commit.sha).commit
          # authored_date = commit.author.date
          commit_date = commit.committer.date
          if commit_date < (Time.now - (60*60*24*inactive_days))
            author_name = commit.author.name
            commit_message = commit.message.split.join(' ')
            puts "On #{commit_date.to_s.colorize(:blue)}, #{author_name.colorize(:red)} created #{branch.name.colorize(:red)} with commit message #{commit_message.colorize(:yellow)}\n"

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
