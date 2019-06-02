class Post < ApplicationRecord
  belongs_to :user
  acts_as_taggable
  acts_as_taggable_on :links

  validate :check_tag_list
  validate :check_link_list
  validate :check_link_list_length
  validate :check_tag_list_length
  validate :check_url_format

  private
    # タグが入力されているか確認
    def check_tag_list
      if self.tag_list.size == 0
        errors.add(:tag_list, "を一つ以上入力してください")
      end
    end

    # リンクが入力されているか確認
    def check_link_list
      if self.link_list.size == 0
        errors.add(:link_list, "を一つ以上入力してください")
      end
    end

    # タグが6つ以上入力されていないか確認
    def check_tag_list_length
      if self.tag_list.length > 5
        errors.add(:link_list, "を6つ以上入力しないでください")
      end
    end

    # リンクが6つ以上入力されていないか確認
    def check_link_list_length
      if self.link_list.length > 5
        errors.add(:link_list, "を6つ以上入力しないでください")
      end
    end

    # リンクが正しいフォーマット確認
    def check_url_format
      self.link_list.each do |link|
        unless !!link.match(/\A(http|https):\/\/[\S]+\z/)
          errors.add(:link_list, "に正しいURLを入力してください")
        end
      end
    end

    # Postオブジェクトを取得する
    def self.setst(post_id, user_id)
      @post = User.find(user_id).posts.find(post_id)
    end

    # タグの検索
    def self.search(tag_list, user_id, page )
      search_tag_list = []
      tag_list.permit!.to_h
      hash_tag_list = tag_list.to_h
      hash_tag_list.each do |tag, state|
        if state.to_i == 1
          search_tag_list << tag
        end
      end
      @tags = User.find(user_id).posts.tags_on(:tags)
      page ||= 1
      User.find(user_id).posts.tagged_with(search_tag_list).page(page).per(10)
    end
end
