# frozen_string_literal: true

require 'io/console'

namespace :diary do
  desc 'Create a new user'
  task create_user: :environment do
    puts 'Create a new user'

    print 'username: '
    username = STDIN.gets.strip

    print 'password: '
    password = STDIN.noecho(&:gets).strip
    puts "\n\n"

    user = User.create!(username: username, password: password)
    puts "Created a new user: #{user.username}" if user
  end
end
