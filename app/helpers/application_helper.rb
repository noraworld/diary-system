module ApplicationHelper

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

end
