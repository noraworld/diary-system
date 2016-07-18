class User < ActiveRecord::Base
  has_secure_password

  validates :username,
    presence: true,
    length: {
      minimum: 4,
      maximum: 20
    }
end
