@javascript
Feature: Starting a game
  In order to play a game 
  As a user
  I should be able to start the game

Scenario: Starting the game
  Given I am logged in
  Given another user has created an unstarted game
  Given I am on the game index page
  Given I have joined the other user's game
  When I start the game
  Then I should see the started game
