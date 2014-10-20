@javascript
Feature: Making an incorrect submission
  In order to verify my words
  As a user
  I should be able to make an incorrect submission

Scenario: Making an incorrect submission  
  Given I am logged in
  Given another user has created an unstarted game
  Given I am on the game index page
  Given I have joined the other user's game
  Given I start the game
  When I make an incorrect submission
  Then I should see an incorrect submission message