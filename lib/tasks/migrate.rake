# frozen_string_literal: true

# This rake task can be removed once the eCTF is migrated to the new setup.
namespace :migrate do
  desc 'Migrate data from PentestGame design pattern to more unified pattern. This is only valid for the eCTF'
  task removeSTI: :environment do
    # Temporarily disable inheritance columns so we can fix our data without errors
    Flag.inheritance_column = :_type_disabled
    Challenge.inheritance_column = :_type_disabled
    Challenge.all.each do |challenge|
      challenge.update!(game: Game.instance)
      challenge.update(type: 'ShareChallenge') if challenge.design_phase?
    end

    Game.instance.update(board_layout: :teams_x_challenges)

    Flag.all.each do |flag|
      if flag.design_phase?
        flag.update(type: 'StandardFlag')
      else
        flag.update(type: 'DefenseFlag')
      end
    end

    PentestSolvedChallenge.all.each do |sc|
      next unless Challenge.find_by(id: sc.challenge_id).type.eql?('ShareChallenge')

      # Have to use update_attribute since the data is already in a bad
      # state and this is fixing it.
      # rubocop:disable Rails/SkipsModelValidations
      sc.update_attribute(:type, 'StandardSolvedChallenge')
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
