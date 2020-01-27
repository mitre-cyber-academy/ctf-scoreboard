# frozen_string_literal: true


# Since this model is a singleton it is a little messy. In order to avoid the default
# constructors stomping all over the values we actually want, the :game factory is
# extremely barebones with no values. This means when :division calls it, most of the
# values are left untouched. We then use :active_jeopardy_game, :ended_jeopardy_game, and :unstarted_jeopardy_game
# in our tests to actually set the values we want game to have.
#
# Do not use the :game factory directly! It should only be used in other Factories
FactoryBot.define do
  factory :game, class: 'Game' do
    id { 1 }

    # This is necessary to duplicate in all the different game types, otherwise you will have an issue with objects
    # being initialized with the wrong type
    initialize_with do
      Game.find_or_initialize_by(id: id)
    end
  end
end
