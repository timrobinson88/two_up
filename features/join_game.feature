Feature: Joining an existing game
  In order to player with other users
  As a user
  I should be able to join an existing game

Scenario:
  Given I am logged in
  Given another user has created an unstarted game
  Given I am on the game index page
  When I have joined the other user's game
  Then I should be able to see the unstarted game