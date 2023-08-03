require "test_helper"

class CommitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @commit = commits(:one)
  end

  test "should get index" do
    get commits_url, as: :json
    assert_response :success
  end

  test "should create commit" do
    assert_difference("Commit.count") do
      post commits_url, params: { commit: { author: @commit.author, category: @commit.category, deleted: @commit.deleted, description: @commit.description, dislikes: @commit.dislikes, likes: @commit.likes, link: @commit.link, title: @commit.title } }, as: :json
    end

    assert_response :created
  end

  test "should show commit" do
    get commit_url(@commit), as: :json
    assert_response :success
  end

  test "should update commit" do
    patch commit_url(@commit), params: { commit: { author: @commit.author, category: @commit.category, deleted: @commit.deleted, description: @commit.description, dislikes: @commit.dislikes, likes: @commit.likes, link: @commit.link, title: @commit.title } }, as: :json
    assert_response :success
  end

  test "should destroy commit" do
    assert_difference("Commit.count", -1) do
      delete commit_url(@commit), as: :json
    end

    assert_response :no_content
  end
end
