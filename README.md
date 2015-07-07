# cuke4skype2slack

A simple hack that parses slack and compares it to your local Skype store telling you whether they are added to Skype or not.

## Requirements

- A Mac
- Skype
- A Slack account
- A Slack token - [https://api.slack.com/tokens]
- Ruby (preferrably installed via RVM [https://rvm.io])

## To run:

- Copy `config_example.yml` into `config.yml`
- Edit config.yml with your bits
- Run `bundle install`
- Run `cucumber`

## Sample output

```bash
 $ cucumber 
Feature: Slack users

  Scenario: Collect slack users and compare against Skype          # features/slack_users.feature:3
    Given there is a slack with an access token                    # features/step_definitions/slack.rb:25
    And there is a Skype sqlite database                           # features/step_definitions/slack.rb:37
    When the slack user list is requested                          # features/step_definitions/slack.rb:45
    And it is compared to the skype database                       # features/step_definitions/slack.rb:60
    Then the list of slack users versus Skype contacts is returned # features/step_definitions/slack.rb:74
      A total of 79 users were found on Slack.
      You have 7 added to Skype.
      You are missing 72 people in Skype.
      Here are the ones you don't have:
		john.doe
		sarah.smith
		wang.lee
		...



1 scenario (1 passed)
5 steps (5 passed)
0m4.875s

```

## TODO:
- Refactor all logic into env.rb so the steps are cleaner and not muddied.
- Get config into env.rb so it doesn't have to be loaded in the first step.
- It should then post back to slack telling you which people you don't have maybe.