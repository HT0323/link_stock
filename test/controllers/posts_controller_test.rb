require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:test1)
    @user2 = users(:test2)
    @post1 = @user1.posts.create(tag_list: 'test', link_list: 'https://test.co.jp')
    @post2 = @user2.posts.create(tag_list: 'test2', link_list: 'https://test2.co.jp')
  end

  test "非ログイン状態で新規作成ページにアクセスできないかを確認" do
    get new_post_path
    assert_redirected_to new_user_session_url
  end

  test "ログイン状態で新規作成ページにアクセスできるか確認" do
    login_as(@user1)
    get new_post_path
    assert_template 'new'
  end

  test "ログイン状態で他のユーザーの投稿の編集ページにアクセスできないかを確認" do
    login_as(@user1)
    get edit_post_path(@post2)
    assert_redirected_to root_url
  end

  test "ログイン状態で自分の投稿の編集ページにアクセスできるかを確認" do
    login_as(@user1)
    get edit_post_path(@post1)
    assert_template 'edit'
  end

  test "ログイン状態で自分の投稿を削除できるか確認" do
    login_as(@user1)
    assert_difference 'Post.count', -1 do
      delete post_path(@post1)
    end
    assert_redirected_to root_url
  end

  test "非ログイン状態で投稿を削除できないか確認" do
    assert_no_difference 'Post.count' do
      delete post_path(@post1)
    end
    assert_redirected_to new_user_session_url
  end

  test "ログイン状態で他のユーザーの投稿を削除できないか確認" do
    login_as(@user1)
    assert_no_difference 'Post.count' do
      delete post_path(@post2)
    end
    assert_redirected_to root_url
  end

end
