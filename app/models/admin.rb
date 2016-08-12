# frozen_string_literal: true
# Basic devise model for managing administrator users.
class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :timeoutable, :lockable
end
