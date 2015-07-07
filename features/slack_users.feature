Feature: Slack users

  Scenario: Collect slack users and compare against Skype
    Given there is a slack with an access token
    And there is a Skype sqlite database
    When the slack user list is requested
    And it is compared to the skype database
    Then the list of slack users versus Skype contacts is returned
