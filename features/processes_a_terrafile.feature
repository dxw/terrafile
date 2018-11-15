Feature: processes a terrafile

  Background:
    And a valid Terrafile exists

  Scenario: all modules are installable
    When I run the _terrafile_ command
    And I should see that each module listed in the Terrafile is to be installed

  Scenario: modules subdirectory created if not present
    When I run the _terrafile_ command
    Then I should see that a _modules_ directory will be created

