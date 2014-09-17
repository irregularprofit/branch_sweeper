Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "inactive_branch"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app's arguments are:
      |repository| which is required |
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--inactive-days|
      |--exclude-branches|
      |--help|
      |--log-level|


  Scenario: App just runs
    When I get help for "inactive_branch"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app's arguments are:
      |repository| which is required |
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |-i|
      |-e|
      |-h|
      |--log-level|

  Scenario: App just runs
    When I get help for "merged_branch"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app's arguments are:
      |repository| which is required |
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--target-branch|
      |--exclude-branches|
      |--help|
      |--log-level|


  Scenario: App just runs
    When I get help for "merged_branch"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app's arguments are:
      |repository| which is required |
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |-t|
      |-e|
      |-h|
      |--log-level|
