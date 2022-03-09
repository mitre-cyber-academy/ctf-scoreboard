# frozen_string_literal: true

module UserHelper
  # All methods named appropriately to work with rails_admin select

  def year_in_school_enum
    [
      %w[9 9], %w[10 10], %w[11 11], %w[12 12],
      ['College - Freshman', '13'],
      ['College - Sophomore', '14'],
      ['College - Junior', '15'],
      ['College - Senior', '16'],
      ['Grad Student/Not in School', '0']
    ]
  end

  def country_enum
    countries = ISO3166::Country.all.map do |country|
      [country.iso_short_name, country.alpha2]
    end

    countries.sort.sort_by { |_name, code| code == 'US' ? 0 : 1 }
  end

  def state_enum
    ISO3166::Country.find_country_by_unofficial_names('United States').states.map { |key, struct| [struct.name, key] }
  end

  def required_for_update?(on_update_page)
    return 'control-label' if on_update_page

    'control-label-required'
  end
end
