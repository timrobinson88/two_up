@javascript
Feature: Making a correct submission that finishes the game
  In order to finish a game
  As a user
  I should be finish the game with a correct submission

Scenario: Finishing the game with a correct submission
  Given I am logged in
  Given another user has created an unstarted game
  Given I am on the game index page
  Given I have joined the other user's game
  Given I start the game
  When I make a correct submission that finishes the game
  Then I should see the finished game view