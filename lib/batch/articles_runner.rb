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

    # bundle exec rails runner Batch::ArticlesRunner.find_legacy_private_tag
    def self.find_legacy_private_tag
      print 'Enter OLD private start tag: '
      private_start_tag = STDIN.gets.strip
      private_end_tag_candidate = "#{private_start_tag[0]}/#{private_start_tag[1..-1]}"

      print "Enter OLD private end tag (#{private_end_tag_candidate}): "
      private_end_tag = STDIN.gets.strip
      puts

      private_end_tag = private_end_tag_candidate if private_end_tag.empty?

      results = []
      Article.all.each do |article|
        results.append("#{Setting.last&.host_name}/#{article.date.to_s.tr('-', '/')}") if article.text.include?(private_start_tag)
        results.append("#{Setting.last&.host_name}/#{article.date.to_s.tr('-', '/')}") if article.text.include?(private_end_tag)

        article.templated_articles.each do |templated_article|
          if templated_article.format == 'sentence'
            results.append("#{Setting.last&.host_name}/#{Article.find(templated_article.article_id).date.to_s.tr('-', '/')}") if templated_article.body.include?(private_start_tag)
            results.append("#{Setting.last&.host_name}/#{Article.find(templated_article.article_id).date.to_s.tr('-', '/')}") if templated_article.body.include?(private_end_tag)
          end
        end
      end

      if results.present?
        results.uniq.each do |result|
          puts result
        end
      else
        puts 'No legacy private tags found. Congrats!'
      end
    end

    # bundle exec rails runner Batch::ArticlesRunner.find_footnotes_inside_of_private_tag
    def self.find_footnotes_inside_of_private_tag
      print 'Enter private start tag: '
      private_start_tag = STDIN.gets.strip
      private_end_tag_candidate = "#{private_start_tag[0]}/#{private_start_tag[1..-1]}"

      print "Enter private end tag (#{private_end_tag_candidate}): "
      private_end_tag = STDIN.gets.strip
      puts

      private_end_tag = private_end_tag_candidate if private_end_tag.empty?

      results = []
      Article.all.each do |article|
        results.append("#{Setting.last&.host_name}/#{article.date.to_s.tr('-', '/')}") if article.text.scan(/#{private_start_tag}\[\^(.*?)\]#{private_end_tag}/).present?

        article.templated_articles.each do |templated_article|
          if templated_article.format == 'sentence'
            results.append("#{Setting.last&.host_name}/#{Article.find(templated_article.article_id).date.to_s.tr('-', '/')}") if templated_article.body.scan(/#{private_start_tag}\[\^(.*?)\]#{private_end_tag}/).present?
          end
        end
      end

      if results.present?
        results.each do |result|
          puts result
        end
      else
        puts 'No footnotes inside of the private tags found. Congrats!'
      end
    end
  end
end
