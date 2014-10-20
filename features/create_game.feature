Feature: Creating a new game
  In order to play my own game
  As a user
  I should be able to create a new game

Scenario: Creating a game
  Given I am logged in
  Given I am on the game index page
  When I create a new game
  Then I should be able to see the unstarted game