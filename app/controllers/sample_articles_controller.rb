class SampleArticlesController < ApplicationController
  def show
    @article = SampleArticle.find_by!(kind: request.path_info.gsub('/', ''))
  end
end
