

def move_tile_to_word(tile, x, y)
  active_tile = page.find(".tile:nth-child(#{tile})")
  driver = page.driver.browser
  driver.mouse.down(active_tile.native)
  driver.mouse.move_by(x, y)
  driver.mouse.up
end

Given(/^I am logged in$/) do
  User.create!(email: "example2@example.com", password: "qwertyui", password_confirmation: "qwertyui")
  visit '/'
  page.fill_in 'Email', :with => 'example2@example.com'
  page.fill_in 'Password', :with=> 'qwertyui'
  click_button 'Log in'
end

When(/^I am on the game index page$/) do
  visit '/games'
end

When(/^I create a new game$/) do
  click_button 'Create new game'
end

Then(/^I should be able to see the unstarted game$/) do
  expect(page).to have_content("Waiting for Game to Commence")
end

Given(/^another user has created an unstarted game$/) do
  gamemaker = User.create!(email: "gamemaker@example.com", password: "qwertyui", password_confirmation: "qwertyui")
  @game = CreateGame.new.make(gamemaker)
end

Then(/^I should be able to see the other user's game$/) do
  expect(page).to have_content("Game started by: gamemaker@example.com")
end

When(/^I have joined the other user's game$/) do
  first(:button, "Join Game").click
end

When(/^I start the game$/) do

  click_button "Start Game Now"
  @game.tiles.destroy_all
  tiles = %w(h e l l o w o r l d)
  tiles.each {|value| @game.tiles.create(value: value)}
  visit current_path
end

Then(/^I should see the started game$/) do
  expect(page).to have_content("Game in Progress")
end

When(/^I make an incorrect submission$/) do
  move_tile_to_word(1, 500, -200)
  move_tile_to_word(2, 575, -200)
  move_tile_to_word(3, 650, -200)
  move_tile_to_word(4, 725, -200)
  move_tile_to_word(5, 800, -200)
  move_tile_to_word(6, 500, -100)
  move_tile_to_word(7, 575, -100)
  move_tile_to_word(8, 650, -100)
  move_tile_to_word(9, 725, -100)
  move_tile_to_word(10, 800, 0)
  click_button "Two Up!"
end

Then(/^I should see an incorrect submission message$/) do
  expect(page).to have_content("You would make an awful word smith rookie")
end

When(/^I make a correct submission that doesn't finish the game$/) do
  move_tile_to_word(1, 500, -200)
  move_tile_to_word(2, 575, -200)
  move_tile_to_word(3, 650, -200)
  move_tile_to_word(4, 725, -200)
  move_tile_to_word(5, 800, -200)
  move_tile_to_word(6, 500, -100)
  move_tile_to_word(7, 575, -100)
  move_tile_to_word(8, 650, -100)
  move_tile_to_word(9, 725, -100)
  move_tile_to_word(10, 800, -100)
  click_button "Two Up!"
end

Then(/^I should see the correct submission message$/) do
  expect(page).to have_content("nailed it boy")
end

When(/^I make a correct submission that finishes the game$/) do
  @game.max_tile_count = 10
  @game.save
  visit current_path
  move_tile_to_word(1, 500, -200)
  move_tile_to_word(2, 575, -200)
  move_tile_to_word(3, 650, -200)
  move_tile_to_word(4, 725, -200)
  move_tile_to_word(5, 800, -200)
  move_tile_to_word(6, 500, -100)
  move_tile_to_word(7, 575, -100)
  move_tile_to_word(8, 650, -100)
  move_tile_to_word(9, 725, -100)
  move_tile_to_word(10, 800, -100)
  click_button "Two Up!"
end

Then(/^I should see the finished game view$/) do
  expect(page).to have_content("Game Finished!")
end
