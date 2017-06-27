# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.transform(name)
    temp = name.dup
    temp.downcase!
    temp.tr! ' ', '_'
    temp.tr! '@', 'a'
    temp.tr! '$', 's'
    temp.gsub!(/[^a-z0-9_]/, '')
    temp
  end
end
