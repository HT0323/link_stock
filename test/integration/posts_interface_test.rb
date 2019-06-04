require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:test1)
    @post = @user.posts.create(tag_list: 'test', link_list: 'https://test.co.jp')
  end

  test "投稿の新規作成" do
    login_as(@user)
    # 無効な送信
    get new_post_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { tag_list: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { tag_list: "ssss,s", link_list: "https://example.com/0" } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert !flash.empty?
    assert_match 'https://example.com/0', response.body
  end

  test "投稿の編集" do
    login_as(@user)
    get edit_post_path(@post)
    # 無効な送信
    assert_no_difference 'Post.count' do
      post posts_path(@post), params: { post: { tag_list: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    assert_difference 'Post.count', 1 do
      post posts_path(@post), params: { post: { tag_list: "test2", link_list: "https://example.com/1" } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert !flash.empty?
    assert_match 'https://example.com/1', response.body
  end

  test "投稿の削除" do
    login_as(@user)
    get root_path
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    follow_redirect!
    assert !flash.empty?
  end
end
