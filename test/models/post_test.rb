require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = users(:test).posts.build(memo: 'test')
    @post.tag_list.add(%w(test1 test2 test3 test4 test5))
    @post.link_list.add(%w(https://test1.com https://test2.com https://test3.com https://test4.com https://test5.com))
  end

  test "オブジェクトの有効性" do
    assert @post.valid?
  end

  test "タグの必要性を確認" do
    @post.tag_list.clear
    assert_not @post.valid?
  end
  test "タグが６つ以上増やせないか確認" do
    @post.tag_list.add('test6')
    assert_not @post.valid?
  end

  test "リンクの必要性を確認" do
    @post.link_list.clear
    assert_not @post.valid?
  end

  test "リンクが６つ以上増やせないか確認" do
    @post.link_list.add('test6')
    assert_not @post.valid?
  end

  test "正しいフォーマットのリンクが保存できるか確認" do
    @post.link_list.clear
    @post.link_list.add(%w(http://test.co.jp/posts/index https://test.co.jp/posts))
    assert @post.valid?
  end

  test "不正なフォーマットのリンクが保存できないか確認" do
    @post.link_list.clear
    @post.link_list.add('test://test.co.jp')
    assert_not @post.valid?
  end

end
