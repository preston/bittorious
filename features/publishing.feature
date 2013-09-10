Feature: Publishing
  In order to distribute data
  As a publisher
  I want to be able to create a feed

  @javascript
  Scenario: Create new feed
    Given I am logged in as an admin
    And I visit the Dashboard
    When I click the button "Create a feed."
    Then "#create_feed_dialog" should be visible
    When I fill in "Name" with "Test Feed"
    And I click the link "Create the feed!"