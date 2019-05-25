class Post < ApplicationRecord
  belongs_to :user
  acts_as_taggable
  acts_as_taggable_on :links

  validate :check_tag_list
  validate :check_link_list
  validate :check_link_list_length
  validate :check_tag_list_length

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

    # Postオブジェクトを取得する
    def self.set_post(post_id, user_id)
      @post = User.find(user_id).posts.find(post_id)
    end
end
