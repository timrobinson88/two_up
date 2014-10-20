Feature: Viewing an existing game
  In order to play with other users
  As a user
  I should be able to see existing games

Scenario: Viewing an existing Game
  Given I am logged in
  Given another user has created an unstarted game
  When I am on the game index page
  Then I should be able to see the other user's game


