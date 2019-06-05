require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:test1)
    @post = @user.posts.create(tag_list: 'test, test2', link_list: 'https://test.co.jp')
    @post2 = @user.posts.create(tag_list: 'test2', link_list: 'https://test.co.jp/2')
    @post3 = @user.posts.create(tag_list: 'test', link_list: 'https://test.co.jp/3')
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

  test "投稿の検索" do
    login_as(@user)
    get root_path
    get root_path, params: {search_tag_list: {
        test: 1, test2: 1
                    }}
    assert_match 'https://test.co.jp', response.body
    assert_no_match 'https://test.co.jp/2', response.body
    assert_no_match 'https://test.co.jp/3', response.body
  end
end
