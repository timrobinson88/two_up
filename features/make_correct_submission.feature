@javascript
Feature: Making a correct submission
  In order to advance the game
  As a user
  I should be advance the game with a correct submission

Scenario: Making a correct submission  
  Given I am logged in
  Given another user has created an unstarted game
  Given I am on the game index page
  Given I have joined the other user's game
  Given I start the game
  When I make a correct submission that doesn't finish the game
  Then I should see the correct submission message