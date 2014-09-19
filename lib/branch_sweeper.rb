require "branch_sweeper/version"
require 'octokit'
require 'netrc'
require 'highline/import'
require 'socket'

require 'branch_sweeper/inactive'
require 'branch_sweeper/merged'

module BranchSweeper
  def self.github
    @@github ||= self.init_client
  end

  def self.init_client
    client = Octokit::Client.new(netrc: true)

    begin
      client.user
    rescue Octokit::Unauthorized => exception
      begin
        login = ask("Enter your login: ")
        password = ask("Enter your password: ") { |q| q.echo = false }

        valid = Octokit.validate_credentials(login: login, password: password)
      end while !valid

      client = Octokit::Client.new(login: login, password: password)
      token = client.create_authorization(scopes: ["repo"], note: "Branch Sweeper #{Socket.gethostname}").token

      n = Netrc.read
      n["api.github.com"] = login, token
      n.save

      client = Octokit::Client.new(netrc: true)
    end

    return client
  end

end
