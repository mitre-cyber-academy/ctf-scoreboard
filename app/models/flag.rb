class Flag < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :flags
end
