class User < ActiveRecord::Base
  include Clearance::User

  has_many :connected_apps, inverse_of: :user
end
