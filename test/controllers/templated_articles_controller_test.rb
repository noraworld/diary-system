require 'test_helper'

class TemplatedArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get templated_articles_create_url
    assert_response :success
  end

  test "should get update" do
    get templated_articles_update_url
    assert_response :success
  end

end
