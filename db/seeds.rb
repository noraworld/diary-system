# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.production?
  puts 'Do nothing because you are in production environment.'
  return
end

def create_sample_article
  year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
  month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
  day   = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%d').to_i

  article = Article.find_by(year: year, month: month, day: day)

  if article
    puts 'Today’s post already exists.'
    print 'Overwrite? [Y/n] : '
    input = STDIN.gets.chomp
    puts ''

    if input == 'Y'
      article.destroy
    else
      puts 'Canceled.'
      return
    end
  end

  text = File.read(Rails.root.join('SAMPLE.md'))
  date = Date.new(year, month, day)

  if Article.create(text: text, year: year, month: month, day: day, date: date)
    puts 'Saved post successfully.'
  else
    puts 'Sorry, cannot save post. Something went wrong.'
  end
end

create_sample_article
