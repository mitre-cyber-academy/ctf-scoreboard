class UserRequest < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
end
