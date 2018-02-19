# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

text  = File.read(Rails.root.join('SAMPLE.md'))
year  = 2000
month = 1
day   = 1
date  = Date.new(year, month, day)
kind  = 'sample'
sample = SampleArticle.find_by(kind: kind)
if sample
  sample.destroy
end
SampleArticle.create(text: text, year: year, month: month, day: day, date: date, kind: kind)
