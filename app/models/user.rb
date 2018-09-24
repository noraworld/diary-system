# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :username,
            presence: true,
            length: {
              minimum: 4,
              maximum: 20
            }
end
