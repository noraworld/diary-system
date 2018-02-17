module ApplicationHelper

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

  # Qiita::Markdownを使用する
  def qiita_markdown(markdown)
    processor = Qiita::Markdown::Processor.new(hostname: ENV['HOST_NAME'], script: true)
    processor.call(markdown)[:output].to_s.html_safe
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
  def to_english_month (month, short = nil)

    month = month.to_i

    case month
    when 1
      english_month = 'January'
    when 2
      english_month = 'February'
    when 3
      english_month = 'March'
    when 4
      english_month = 'April'
    when 5
      english_month = 'May'
    when 6
      english_month = 'June'
    when 7
      english_month = 'July'
    when 8
      english_month = 'August'
    when 9
      english_month = 'September'
    when 10
      english_month = 'October'
    when 11
      english_month = 'November'
    when 12
      english_month = 'December'
    else
      english_month = 'Error!'
    end

    # 先頭からshortに設定された数値までを表示する
    if (short.is_a?(Integer))
      english_month = english_month[0..(short-1)]
    end

    return english_month
  end

  def to_day_of_week (wday, short = nil)

    wday = wday.to_i

    case wday
    when 0
      wday = 'Sunday'
    when 1
      wday = 'Monday'
    when 2
      wday = 'Tuesday'
    when 3
      wday = 'Wednesday'
    when 4
      wday = 'Thursday'
    when 5
      wday = 'Friday'
    when 6
      wday = 'Saturday'
    else
      wday = 'Error!'
    end

    if (short.is_a?(Integer))
      wday = wday[0..(short-1)]
    end

    return wday
  end

  # 改行コードをbrタグに変換する
  # text: 変換するテキスト(text)
  # return -> brタグつきのテキスト(text)
  def linebreak_to_br(text)
    text.gsub(/\r\n|\r|\n/, "<br>")
  end

end
