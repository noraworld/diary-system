# frozen_string_literal: true

class ExportsController < ApplicationController
  DEFAULT_REPLACEMENT_SENTENCE = ' (this is a private diary) '

  include ApplicationHelper
  extend ActiveSupport::Concern

  before_action :signed_in?
  before_action :article_exists?

  def index; end

  def create
    zip_file_name = "diary_archive_#{Time.current.to_date.to_s.delete('-')}.zip"

    clean_files(zip_file_name)

    Article.all.each do |article|
      replacement_sentence   = params[:replacement_sentence] || DEFAULT_REPLACEMENT_SENTENCE
      year                   = article.year.to_s
      month                  = format('%<number>02d', number: article.month)
      day                    = format('%<number>02d', number: article.day)
      public_directory_path  = Rails.root.join('public', 'exports', 'public', year, month)
      private_directory_path = Rails.root.join('public', 'exports', 'private', year, month)
      public_file_path       = "#{public_directory_path}/#{year}-#{month}-#{day}-.md"
      private_file_path      = "#{private_directory_path}/#{year}-#{month}-#{day}-.md"
      public_content         = ''
      private_content        = ''

      # $ mkdir -p /path/to/diary-system/public/exports/public/2023/03
      # $ mkdir -p /path/to/diary-system/public/exports/private/2023/03
      FileUtils.mkdir_p(public_directory_path) unless File.directory?(public_directory_path)
      FileUtils.mkdir_p(private_directory_path) unless File.directory?(private_directory_path)

      # $ touch /path/to/diary-system/public/exports/public/2023/03/2023-03-07-.md
      # $ touch /path/to/diary-system/public/exports/private/2023/03/2023-03-07-.md
      public_file  = File.new(public_file_path, 'w')
      private_file = File.new(private_file_path, 'w')

      public_content += "#{trim_private_contents_for_export(article.text, replacement_sentence)}\n\n\n\n"
      private_content += "#{extract_private_contents_for_export(article.text)}\n\n\n\n"

      article.templated_articles.order('position').each do |templated_article|
        next if unnecessary?(templated_article)

        if templated_article.is_private
          private_content += "# #{templated_article.title}\n#{templated_article.body}\n\n\n\n"
        else
          public_content += "# #{templated_article.title}\n#{trim_private_contents_for_export(templated_article.body, replacement_sentence)}\n\n\n\n"
          private_content += "#{extract_private_contents_for_export(templated_article.body)}\n\n\n\n"
        end
      end

      # Delete unnecessary newline letters at the end of the file
      public_content.chomp!('')
      private_content.chomp!('')

      public_file.puts public_content
      private_file.puts private_content

      public_file.close
      private_file.close

      # Delete a file if it's empty (including the file that contains only newline letters)
      File.delete(public_file_path) if File.read(public_file_path).gsub(/\r\n|\r|\n/, '').blank?
      File.delete(private_file_path) if File.read(private_file_path).gsub(/\r\n|\r|\n/, '').blank?
    end

    # "/path/to/diary-system/public/exports" -> (zip) -> "/path/to/diary-system/public/diary_archive_20230307.zip"
    directory_to_zip   = Rails.root.join('public', 'exports').to_s
    output_file        = Rails.root.join('public', zip_file_name).to_s
    zip_file_generator = ZipFileGenerator.new(directory_to_zip, output_file)
    zip_file_generator.write

    send_data(File.read(Rails.root.join('public', zip_file_name).to_s), filename: zip_file_name)

    clean_files(zip_file_name)

    # TODO: Fix the inconvenience that the export button doesn't get clickable after clicking once
  end

  private

  def clean_files(zip_file_name)
    FileUtils.rm_rf(Rails.root.join('public', 'exports')) if File.directory?(Rails.root.join('public', 'exports'))
    File.delete(Rails.root.join('public', zip_file_name).to_s) if File.exist?(Rails.root.join('public', zip_file_name).to_s)
  end

  def unnecessary?(templated_article)
    return true if templated_article.body.blank?
    return true if templated_article.body == templated_article.template_body

    false
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end

  def article_exists?
    redirect_to root_path, alert: 'There are no articles!' if Article.count.zero?
  end
end
