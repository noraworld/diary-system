# frozen_string_literal: true

# bundle exec rails runner Batch::ArticlesRunner
module Batch
  class ArticlesRunner
    # bundle exec rails runner Batch::ArticlesRunner.migrate_private_tag
    def self.migrate_private_tag
      print 'Enter OLD private START tag: '
      old_private_start_tag = STDIN.gets.strip
      old_private_end_tag_candidate = "#{old_private_start_tag[0]}/#{old_private_start_tag[1..-1]}"

      print 'Enter NEW private START tag: '
      new_private_start_tag = STDIN.gets.strip
      new_private_end_tag_candidate = "#{new_private_start_tag[0]}/#{new_private_start_tag[1..-1]}"

      print "Enter OLD private END tag (#{old_private_end_tag_candidate}): "
      old_private_end_tag = STDIN.gets.strip

      print "Enter NEW private END tag (#{new_private_end_tag_candidate}): "
      new_private_end_tag = STDIN.gets.strip

      old_private_end_tag = old_private_end_tag_candidate if old_private_end_tag.empty?
      new_private_end_tag = new_private_end_tag_candidate if new_private_end_tag.empty?

      puts "\nMigrate the private tags to the following:\n\n"
      puts "#{old_private_start_tag} => #{new_private_start_tag}"
      puts "#{old_private_end_tag} => #{new_private_end_tag}\n\n"

      print 'WARNING!!! THIS OPERATION CANNOT BE UNDONE! Are you sure you want to execute this operation? [Y/n]: '
      confirmation = STDIN.gets.strip

      if confirmation != 'Y'
        puts 'Canceled'
        return
      end

      Article.all.each do |article|
        article.text = article.text.gsub(old_private_start_tag, new_private_start_tag).gsub(old_private_end_tag, new_private_end_tag)
        article.save!

        article.templated_articles.each do |templated_article|
          if templated_article.format == 'sentence'
            templated_article.body = templated_article.body.gsub(old_private_start_tag, new_private_start_tag).gsub(old_private_end_tag, new_private_end_tag)
            templated_article.save!
          end
        end
      end

      # Check
      Article.all.each do |article|
        puts "CAUTION!!! #{old_private_start_tag}  still left! Perhaps this script has a critical bug." if article.text.include?(old_private_start_tag)
        puts "CAUTION!!! #{old_private_end_tag} still left! Perhaps this script has a critical bug."    if article.text.include?(old_private_end_tag)

        article.templated_articles.each do |templated_article|
          if templated_article.format == 'sentence'
            puts "CAUTION!!! #{old_private_start_tag}  still left! Perhaps this script has a critical bug." if templated_article.body.include?(old_private_start_tag)
            puts "CAUTION!!! #{old_private_end_tag} still left! Perhaps this script has a critical bug."    if templated_article.body.include?(old_private_end_tag)
          end
        end
      end

      puts 'Done!'
    end
  end
end
