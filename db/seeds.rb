# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'rbclark@mitre.org', password: 'ChangeMe123', admin: true)

# default game
game = Game.create!(name: 'Test Game', start: Time.now.utc, stop: Time.now.utc + 2.days)

division1 = Division.create!(name: 'High School', game: game)
division2 = Division.create!(name: 'College', game: game)

# players
team1 = Team.create!(team_name: 'pwnies', affiliation: 'PwnPwnPwn', division: division1, eligible: false)
User.create!(
  email: 'ctf@mitre.org',
  username: 'pwn',
  password: 'Test123456',
  team: team1,
  full_name: 'I Pwn',
  affiliation: 'PwnPwnPwn',
  year_in_school: 12,
  gender: 'Male',
  age: 16,
  area_of_study: 'Robotics',
  state: 'FL'
)

Team.create!(team_name: 'n00bs', affiliation: "We're n00bs", division: division2, eligible: true)

# crypto
category = Category.create!(name: 'Crypto', game: game)
Challenge.create!(
  name: 'Challenge A',
  point_value: 100,
  flags: [Flag.create(flag: 'flag')],
  state: 'open',
  category: category
)
Challenge.create!(
  name: 'Challenge B',
  point_value: 200,
  flags: [Flag.create(flag: 'flag')],
  state: 'closed',
  category: category
)
Challenge.create!(
  name: 'Challenge C',
  point_value: 300,
  flags: [Flag.create(flag: 'flag')],
  state: 'closed',
  category: category
)
Challenge.create!(
  name: 'Challenge D',
  point_value: 400,
  flags: [Flag.create(flag: 'flag')],
  state: 'closed',
  category: category
)

category = Category.create!(name: 'Forensics', game: game)
Challenge.create!(
  name: 'Challenge E',
  point_value: 100,
  flags: [Flag.create(flag: 'flag')],
  state: 'open',
  category: category
)
Challenge.create!(
  name: 'Challenge F',
  point_value: 200,
  flags: [Flag.create(flag: 'flag')],
  state: 'closed',
  category: category
)
Challenge.create!(
  name: 'Challenge G',
  point_value: 300,
  flags: [Flag.create(flag: 'flag')],
  state: 'closed',
  category: category
)
Challenge.create!(
  name: 'Challenge H',
  point_value: 400,
  flags: [Flag.create(flag: 'flag')],
  state: 'closed',
  category: category
)

Message.create!(
  game: game,
  text: "Message",
  title: "Neat message",
)
