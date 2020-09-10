# frozen_string_literal: true

class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :year, :month, :day, :date, :public

  def public
    current_user.present? || object.date + object.public_in.to_i < instance_options[:adjusted_current_time].to_date
  end
end
