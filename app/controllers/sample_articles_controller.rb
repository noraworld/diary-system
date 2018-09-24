# frozen_string_literal: true

class SampleArticlesController < ApplicationController
  def show
    @article = SampleArticle.find_by!(kind: request.path_info.delete('/'))
  end
end
