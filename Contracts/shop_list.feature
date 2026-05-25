Feature: Sake Shop List
  As a user
  I want to see a list of local sake shops
  So that I can discover places to visit

  Scenario: Display all shops
    Given the app has shop data available
    When I open the shop list
    Then I should see all shops
    And each shop item displays the name
    And each shop item displays the address
    And each shop item displays the star rating

  Scenario: Navigate to shop detail
    Given I am on the shop list screen
    When I tap on a shop
    Then I should be taken to the shop detail screen
    And the detail screen displays the name of the selected shop
    And the detail screen displays the address of the selected shop
    And the detail screen displays the rating of the selected shop

  Scenario: Handle missing shop picture gracefully
    Given a shop has no picture available
    When I view that shop in the list
    Then a placeholder image is shown instead
