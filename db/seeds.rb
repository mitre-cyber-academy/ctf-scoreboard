# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'root@root.com', password: 'ChangeMe123', confirmed_at: Time.now.utc, admin: true)

# default game
game = Game.create!(
  title: 'Test Game',
  organization: 'MITRE',
  start: Time.now.utc + 3.months,
  stop: Time.now.utc + 3.months + 2.days,
  do_not_reply_email: 'do-not-reply@mitrestemctf.org',
  contact_email: 'contact@mitrestemctf.org',
  description: "#h1\nCTF description",
  recruitment_text: 'While this competition was open to professional and government participants as part '\
    'of cyber training, only eligible teams composed of high school and college students will be considered for '\
    'winning prizes, scholarships and internships. Participation in a MITRE or industry partner cyber internship '\
    'program is subject to an interviewing process and based on current business needs.'
)

high_school = Division.create!(name: 'High School', game: game, min_year_in_school: 9, max_year_in_school: 12)
college = Division.create!(name: 'College', game: game, min_year_in_school: 9, max_year_in_school: 16)
Division.create!(name: 'Professional', game: game, min_year_in_school: 0, max_year_in_school: 16)

user = User.create!(
  email: 'ctf@mitre.org',
  password: 'Test123456',
  full_name: 'I Pwn',
  affiliation: 'PwnPwnPwn',
  year_in_school: 12,
  age: 16,
  area_of_study: 'Robotics',
  confirmed_at: Time.now.utc,
  state: 'FL'
)

college_user = User.create!(
  email: 'ftc@mitre.org',
  password: 'Test123456',
  full_name: 'ctf is fun',
  affiliation: 'hax0r',
  year_in_school: 14,
  age: 20,
  area_of_study: 'Robotics',
  confirmed_at: Time.now.utc,
  state: 'FL'
)

team1 = Team.create!(
  team_name: 'pwnies',
  affiliation: 'PwnPwnPwn',
  division: high_school,
  eligible: false,
  users: [user],
  team_captain: user
)

team2 = Team.create!(
  team_name: 'hax0rs',
  affiliation: 'CollegePwn2Win',
  division: college,
  eligible: false,
  users: [college_user],
  team_captain: college_user
)

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
  text: 'Message',
  title: 'Neat message'
)

FeedItem.create!(
  team: team1,
  user: user,
  division: high_school,
  challenge: Challenge.first,
  text: 'Achievement',
  type: Achievement
)

FeedItem.create!(
  team: team2,
  user: college_user,
  division: college,
  challenge: Challenge.first,
  text: 'Cool & Neat',
  type: Achievement
)
