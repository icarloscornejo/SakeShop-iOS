Feature: Shop Data Loading
  As a user
  I want the app to load shop data reliably
  So that I always see up-to-date content

  Scenario: Successfully load shop data from local source
    Given the local shop data source is available
    When the app initializes the shop list
    Then all shops are loaded and displayed

  Scenario: Show loading state while data is being fetched
    Given the shop data source is loading
    When I open the shop list
    Then a loading indicator is displayed to the user

  Scenario: Handle empty data gracefully
    Given the shop data source returns no shops
    When I open the shop list
    Then an empty state message is displayed

  Scenario: Handle data loading error
    Given the shop data source fails to load
    When I open the shop list
    Then an error message is displayed to the user

  Scenario: Retry after error
    Given an error message is displayed to the user
    When I tap the retry button
    Then the app attempts to load shop data again

  Scenario: Handle partial data with null fields
    Given a shop in the data source has one or more null optional fields
    When the app loads that shop
    Then the shop is displayed without crashing
    And missing fields show a safe default or are hidden

  Scenario: Handle malformed JSON
    Given the shop data source contains malformed JSON
    When the app attempts to parse the data
    Then an error message is displayed to the user
    And the app does not crash
