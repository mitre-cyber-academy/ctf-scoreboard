# frozen_string_literal: true

# Since this model is a singleton it is a little messy. In order to avoid the default
# constructors stomping all over the values we actually want, the :game factory is
# extremely barebones with no values. This means when :division calls it, most of the
# values are left untouched. We then use :active_game, :ended_game, and :unstarted_game
# values are left untouched. We then use :active_jeopardy_game, :ended_jeopardy_game, and :unstarted_jeopardy_game
# in our tests to actually set the values we want game to have.

FactoryBot.define do
  factory :game do
    id { 1 }

    initialize_with { Game.find_or_initialize_by(id: id) }

    factory :active_game do
      organization { 'MITRE CTF' }
      title { 'Cyber Challenge 2019' }
      description { 'MITRE CTF Game' }
      start { Time.now.utc }
      stop { Time.now.utc + 10.hours }
      contact_email { Faker::Internet.free_email }
      prizes_available { false }
      team_size { 5 }
      enable_completion_certificates { false }
      recruitment_text { 'Jobs and internships are available if you meet the following requirements' }
      prizes_text { 'Prizes are available if you meet the following requirements' }
      board_layout { :jeopardy }

      completion_certificate_template {
        if enable_completion_certificates
          File.open(Rails.root.join('test/files/ctf-certificate-template.jpg'))
        else
          nil
        end
      }

      transient do
        message_count { 1 }
        division_count { 1 }
        category_count { 1 }
      end

      after(:create) do |game, evaluator|
        evaluator.message_count.times do
          create(:message, game: game)
        end

        evaluator.division_count.times do
          create(:division, game: game)
        end

        evaluator.category_count.times do
          create(:category, game: game)
        end
      end

      factory :ended_game do
        start { Time.now.utc - 9.hours }
        stop { Time.now.utc - 1.hours }
      end

      factory :unstarted_game do
        start { Time.now.utc + 1.hours }
        stop { Time.now.utc + 9.hours }
      end
    end
  end
end
