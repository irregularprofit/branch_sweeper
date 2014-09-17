Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "inactive_branch"
    Then the exit status should be 0
    Then the banner should include the version
    And the banner should be present
    And the banner should document that this app's arguments are:
      |repository| which is required |
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version         | which is not negatable |
      |--inactive-days   | which is not negatable |
      |--exclude-branches| which is not negatable |
      |--help            | which is not negatable |
      |--log-level       | which is not negatable |


  Scenario: App just runs
    When I get help for "inactive_branch"
    Then the exit status should be 0
    Then the banner should include the version
    And the banner should be present
    And the banner should document that this app's arguments are:
      |repository| which is required |
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version   | which is not negatable |
      |-i          | which is not negatable |
      |-e          | which is not negatable |
      |-h          | which is not negatable |
      |--log-level | which is not negatable |
