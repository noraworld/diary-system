# frozen_string_literal: true

module ApplicationHelper
  class NoMatchingPrivateStringError < StandardError; end

  PRIVATE_START_STRING = '{private}'
  PRIVATE_END_STRING   = '{/private}'

  REPLACED_PRIVATE_START_INLINE_TAG = '<span class="private-sentence inline">'
  REPLACED_PRIVATE_END_INLINE_TAG   = '</span>'

  REPLACED_PRIVATE_START_BLOCK_TAG = '<div class="private-sentence block">'
  REPLACED_PRIVATE_END_BLOCK_TAG   = '</div>'

  def site_title
    settings_site_title = Setting.last&.site_title
    settings_host_name = Setting.last&.host_name

    if settings_site_title.present?
      settings_site_title
    elsif settings_host_name.present?
      settings_host_name
    else
      request.domain
    end
  end

  # ページごとにタイトルを変更する
  def page_title
    settings_site_title = Setting.last&.site_title

    if @page_title.present? && settings_site_title.present?
      @page_title.to_s + ' - ' + settings_site_title.to_s
    elsif @page_title.present? && settings_site_title.blank?
      @page_title.to_s + ' - ' + request.domain
    elsif @page_title.blank? && settings_site_title.present?
      settings_site_title
    elsif @page_title.blank? && settings_site_title.blank?
      request.domain
    end
  end

  # トップページにはサイトの説明文、記事の詳細には、記事内容の要約を meta description に設定する
  def page_description
    settings_site_description = Setting.last&.site_description

    if @page_description == false
      false
    elsif @page_description.present?
      @page_description.to_s
    elsif settings_site_description.present?
      settings_site_description.to_s
    else
      false
    end
  end

  # Copyright の年を適切に表示させる
  def copyright_year
    settings_launched_since = Setting.last&.launched_since
    now = adjusted_current_time.strftime('%Y').to_s

    since = if settings_launched_since.present? && settings_launched_since.to_i != 0
              settings_launched_since.to_s
            else
              adjusted_current_time.strftime('%Y').to_s
            end

    if since.to_i < now.to_i
      since + '-' + now
    else
      now
    end
  end

  # Qiita::Markdownを使用する
  def qiita_markdown(markdown, format = nil)
    if format.nil? || format == 'sentence'
      settings_host_name = Setting.last&.host_name
      processor = Qiita::Markdown::Processor.new(hostname: settings_host_name, script: true)
      markdown = processor.call(markdown)[:output].to_s
    end

    markdown.present? ? trim_private_contents(markdown).html_safe : markdown # rubocop:disable Rails/OutputSafety
  end

  # 検索結果や meta description に表示させる 200 文字程度の要約
  def qiita_markdown_summary(markdown)
    settings_host_name = Setting.last&.host_name
    public_contents = markdown.present? ? trim_private_contents(markdown) : markdown

    # length は omission の文字列を含むので、omission の文字列の長さだけ length を増やす
    processor = Qiita::Markdown::SummaryProcessor.new(truncate: { length: 204, omission: ' ...' }, hostname: settings_host_name)
    # 1 つ以上の改行は 1 つのスペースに置き換える。さらに、ポエム式記述法で、改行直前に句読点がある場合は、置き換えたスペースを省略する。
    strip_tags(processor.call(public_contents)[:output].to_s).gsub(/\n+/, ' ').gsub('、 ', '、').gsub('。 ', '。')
  end

  def file_storage
    ActiveRecord::Type::Boolean.new.cast(ENV.fetch('S3_ENABLED')) ? 's3' : 'local'
  end

  # 数値の月表記を英語の月表記に変換する
  # month: 変換する月(integer), short: 先頭から何文字まで表示するか
  # return -> 英語の月表記(string)
  def to_english_month(month, short = nil)
    month = month.to_i

    english_month = case month
                    when 1
                      'January'
                    when 2
                      'February'
                    when 3
                      'March'
                    when 4
                      'April'
                    when 5
                      'May'
                    when 6
                      'June'
                    when 7
                      'July'
                    when 8
                      'August'
                    when 9
                      'September'
                    when 10
                      'October'
                    when 11
                      'November'
                    when 12
                      'December'
                    else
                      'Error!'
                    end

    # 先頭からshortに設定された数値までを表示する
    english_month = english_month[0..(short - 1)] if short.is_a?(Integer)

    english_month
  end

  def to_day_of_week(wday, short = nil)
    wday = wday.to_i

    wday = case wday
           when 0
             'Sunday'
           when 1
             'Monday'
           when 2
             'Tuesday'
           when 3
             'Wednesday'
           when 4
             'Thursday'
           when 5
             'Friday'
           when 6
             'Saturday'
           else
             'Error!'
           end

    wday = wday[0..(short - 1)] if short.is_a?(Integer)

    wday
  end

  # 改行コードをbrタグに変換する
  # text: 変換するテキスト(text)
  # return -> brタグつきのテキスト(text)
  def linebreak_to_br(text)
    text.gsub(/\r\n|\r|\n/, '<br>')
  end

  private

  #########################################################################################################
  ###                                                                                                   ###
  ### TAKE CARE WHEN EDITING THIS METHOD BECAUSE IT CAN CAUSE EXPOSURE OF PRIVATE CONTENTS TO PUBLIC!!! ###
  ###                                                                                                   ###
  #########################################################################################################
  def trim_private_contents(markdown)
    private_start_string_length = markdown.scan(PRIVATE_START_STRING).length
    private_end_string_length   = markdown.scan(PRIVATE_END_STRING).length

    unless private_start_string_length == private_end_string_length
      raise NoMatchingPrivateStringError, 'The private start string and the private end string did not match (BEFORE PARSE)'
    end

    return markdown if private_start_string_length.zero? && private_end_string_length.zero?

    # for not signed in
    # raise error to perceive it also when signed in
    trimmed_markdown = markdown.gsub(/(\r\n|\r|\n)?#{PRIVATE_START_STRING}.*?#{PRIVATE_END_STRING}/m, '')
    if !trimmed_markdown.scan(PRIVATE_START_STRING).length.zero? || !trimmed_markdown.scan(PRIVATE_END_STRING).length.zero?
      raise NoMatchingPrivateStringError, 'The private start string and the private end string did not match (AFTER PARSE, FOR NOT SIGNED IN)'
    end

    return trimmed_markdown unless signed_in?

    #                                                                #
    # THE PROCESS BELOW HERE SHOULD BE EXECUTED ONLY WHEN SIGNED IN! #
    #                                                                #

    # for signed in
    # trimmed_markdown = markdown.gsub(/#{PRIVATE_START_STRING}/, REPLACED_PRIVATE_START_BLOCK_TAG)
    #                            .gsub(/#{PRIVATE_END_STRING}/, REPLACED_PRIVATE_END_BLOCK_TAG)
    #                            .gsub(/<.+>#{REPLACED_PRIVATE_START_BLOCK_TAG}<.+>/, REPLACED_PRIVATE_START_BLOCK_TAG)
    #                            .gsub(/<.+>#{REPLACED_PRIVATE_END_BLOCK_TAG}<.+>/, REPLACED_PRIVATE_END_BLOCK_TAG)
    trimmed_markdown = markdown.gsub(/#{PRIVATE_START_STRING}(.*?)#{PRIVATE_END_STRING}/m) do |private_sentence|
      if private_sentence.scan(/<.+>/).empty?
        "#{REPLACED_PRIVATE_START_INLINE_TAG}#{private_sentence}#{REPLACED_PRIVATE_END_INLINE_TAG}"
      else
        "#{REPLACED_PRIVATE_START_BLOCK_TAG}#{private_sentence}#{REPLACED_PRIVATE_END_BLOCK_TAG}"
      end
    end.gsub(PRIVATE_START_STRING, '').gsub(PRIVATE_END_STRING, '')

    if !trimmed_markdown.scan(PRIVATE_START_STRING).length.zero? || !trimmed_markdown.scan(PRIVATE_END_STRING).length.zero?
      raise NoMatchingPrivateStringError, 'The private start string and the private end string did not match (AFTER PARSE, FOR SIGNED IN)'
    end

    trimmed_markdown
  end

  def parse_markdown(markdown)
    settings_host_name = Setting.last&.host_name
    processor = Qiita::Markdown::Processor.new(hostname: settings_host_name, script: true)
    processor.call(markdown)[:output].to_s.html_safe # rubocop:disable Rails/OutputSafety
  end

  def signed_in?
    current_user.present?
  end
end
