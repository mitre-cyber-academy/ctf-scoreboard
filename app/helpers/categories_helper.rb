# frozen_string_literal: true

module CategoriesHelper
  def category_ids_to_names(category_ids, categories)
    category_names(categories.select { |category| category_ids.include?(category.id) })
  end

  # Takes a list of categories and returns all their names as a comma separated string,
  # or 'No Category' for an empty list
  def category_names(categories)
    return t('challenges.no_category') if categories.empty?

    categories.map(&:name).join(', ')
  end
end
