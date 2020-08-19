# frozen_string_literal: true

class Survey < ApplicationRecord
  belongs_to :submitted_flag, optional: true
  belongs_to :team
end
