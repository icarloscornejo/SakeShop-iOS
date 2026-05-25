Feature: Sake Shop Detail
  As a user
  I want to see detailed information about a sake shop
  So that I can decide whether to visit and how to get there

  Scenario: Display shop information
    Given I have navigated to a shop detail screen
    Then I should see the shop name
    And I should see the shop picture
    And I should see the shop description
    And I should see the star rating
    And I should see the address

  Scenario: Open address in maps
    Given I am on the shop detail screen
    When I tap the address
    Then the device maps application should open with the shop location

  Scenario: Open website in browser
    Given I am on the shop detail screen
    When I tap the website button
    Then the shop website should open in the default browser

  Scenario: Handle missing shop picture gracefully
    Given a shop has no picture available
    When I navigate to its detail screen
    Then a placeholder image is shown instead of the picture

  Scenario: Handle empty website URL
    Given I am on the shop detail screen
    And the shop has no website URL
    Then the website button should be disabled or hidden

  Scenario: Handle empty maps link
    Given I am on the shop detail screen
    And the shop has no maps link
    Then the address should not be tappable
