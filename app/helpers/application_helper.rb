# frozen_string_literal: true

module ApplicationHelper
  PRIVATE_START_STRING = '<private>'
  PRIVATE_END_STRING   = '</private>'

  def site_title
    if ENV['SITE_TITLE'].present?
      ENV['SITE_TITLE']
    elsif ENV['HOST_NAME'].present?
      ENV['HOST_NAME']
    else
      request.domain
    end
  end

  # ページごとにタイトルを変更する
  def page_title
    if @page_title && ENV['SITE_TITLE']
      @page_title.to_s + ' - ' + ENV['SITE_TITLE'].to_s
    elsif @page_title && !ENV['SITE_TITLE']
      @page_title.to_s + ' - ' + request.domain
    elsif !@page_title && ENV['SITE_TITLE']
      ENV['SITE_TITLE']
    elsif !@page_title && !ENV['SITE_TITLE']
      request.domain
    end
  end

  # トップページにはサイトの説明文、記事の詳細には、記事内容の要約を meta description に設定する
  def page_description
    if @page_description == false
      false
    elsif @page_description
      @page_description.to_s
    elsif ENV['SITE_DESCRIPTION']
      ENV['SITE_DESCRIPTION'].to_s
    else
      false
    end
  end

  # Copyright の年を適切に表示させる
  def copyright_year
    now = Time.now.in_time_zone('Tokyo').strftime('%Y').to_s

    since = if ENV['LAUNCHED_SINCE']
              ENV['LAUNCHED_SINCE'].to_s
            else
              Time.now.in_time_zone('Tokyo').strftime('%Y').to_s
            end

    if since.to_i < now.to_i
      since + '-' + now
    else
      now
    end
  end

  # Qiita::Markdownを使用する
  def qiita_markdown(markdown)
    public_contents = markdown.present? ? trim_private_contents(markdown) : markdown
    processor = Qiita::Markdown::Processor.new(hostname: ENV['HOST_NAME'], script: true)
    processor.call(public_contents)[:output].to_s.html_safe # rubocop:disable Rails/OutputSafety
  end

  # 検索結果や meta description に表示させる 200 文字程度の要約
  def qiita_markdown_summary(markdown)
    # length は omission の文字列を含むので、omission の文字列の長さだけ length を増やす
    processor = Qiita::Markdown::SummaryProcessor.new(truncate: { length: 204, omission: ' ...' }, hostname: ENV['HOST_NAME'])
    # 1 つ以上の改行は 1 つのスペースに置き換える。さらに、ポエム式記述法で、改行直前に句読点がある場合は、置き換えたスペースを省略する。
    strip_tags(processor.call(markdown)[:output].to_s).gsub(/\n+/, ' ').gsub('、 ', '、').gsub('。 ', '。')
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

  def trim_private_contents(markdown)
    private_start_string_length = markdown.scan(PRIVATE_START_STRING).length
    private_end_string_length   = markdown.scan(PRIVATE_END_STRING).length

    raise StandardError unless private_start_string_length == private_end_string_length

    return markdown if private_start_string_length.zero? && private_end_string_length.zero?

    markdown = if signed_in?
                 markdown.gsub(/#{PRIVATE_START_STRING}(\r\n|\r|\n)?/, '').gsub(/(\r\n|\r|\n)?#{PRIVATE_END_STRING}/, '')
               else
                 markdown.gsub(/(\r\n|\r|\n)?#{PRIVATE_START_STRING}.*?#{PRIVATE_END_STRING}/m, '')
               end

    return markdown if markdown.scan(PRIVATE_START_STRING).length.zero? && markdown.scan(PRIVATE_END_STRING).length.zero?

    raise StandardError
  end

  def signed_in?
    current_user.present?
  end
end
