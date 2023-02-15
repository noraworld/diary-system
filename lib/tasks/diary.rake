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

  desc 'Update next day adjustment hour'
  task update_next_day_adjustment_hour: :environment do
    puts 'Update next day adjustment hour'

    print 'next day adjustment hour: '
    next_day_adjustment_hour = STDIN.gets.strip
    puts "\n"

    ok = if Setting.last
           Setting.last.update!(next_day_adjustment_hour: next_day_adjustment_hour.to_i)
         else
           # "site_title" is required to create a record
           Setting.create!(site_title: '', next_day_adjustment_hour: next_day_adjustment_hour.to_i)
         end

    puts "Updated successfully: #{Setting.last.next_day_adjustment_hour} hour(s)" if ok
  end
end
