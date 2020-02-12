FactoryBot.define do
  factory :active_point_game, parent: :game, class: 'PointGame' do
    initialize_with do
      PointGame.find_or_initialize_by(id: id)
    end

    organization { 'MITRE CTF' }
    title { 'Cyber Challenge 2019' }
    description { 'MITRE CTF Game' }
    start { Time.now }
    stop { Time.now + 10.hours }
    do_not_reply_email { Faker::Internet.free_email }
    contact_email { Faker::Internet.free_email }
    open_source_url { Faker::Internet.url(host: 'github.com') }
    prizes_available { false }
    team_size { 5 }
    enable_completion_certificates { false }
    recruitment_text { 'Jobs and internships are available if you meet the following requirements' }
    prizes_text { 'Prizes are available if you meet the following requirements' }
    type { 'PointGame' }

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
        create(:point_division, game: game)
      end

      evaluator.category_count.times do
        create(:category, game: game)
      end
    end

    factory :ended_point_game do
      start { Time.now - 9.hours }
      stop { Time.now - 1.hours }
    end

    factory :unstarted_point_game do
      start { Time.now + 1.hours }
      stop { Time.now + 9.hours }
    end
  end
end
