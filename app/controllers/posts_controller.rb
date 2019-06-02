class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_post_tags_to_gon, only: [:edit, :update]
  before_action :set_available_tags_to_gon, only: [:new, :edit, :create, :update]
  before_action :set_post_links_to_gon, only: [:edit, :update]
  before_action :set_available_links_to_gon, only: [:new, :edit, :create, :update]


  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "作成しました"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:notice] = "編集しました"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def index
    if user_signed_in?
      @tags = current_user.posts.tags_on(:tags)
      if params[:search_tag_list]
        @posts = Post.search(params[:search_tag_list], current_user.id, params[:page])
        return
      end
      @posts = current_user.posts.includes(:tags).page(params[:page]).per(10)
    else
      render template: "static_pages/top"
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      flash[:notice] = '削除しました'
      redirect_to root_path
    end
  end

  private
    def post_params
      params.require(:post).permit(:memo, :tag_list, :link_list)
    end
    # 投稿に紐づいているタグを取得する
    def set_post_tags_to_gon
      @post = Post.set_post(params[:id], current_user.id)
      gon.post_tags = @post.tag_list
    end
    # 作成済みのタグを取得する
    def set_available_tags_to_gon
      gon.available_tags = Post.where(user_id: current_user.id).tags_on(:tags).pluck(:name)
    end
    # 投稿に紐づいているリンクを取得する
    def set_post_links_to_gon
      @post = Post.set_post(params[:id], current_user.id)
      gon.post_links = @post.link_list
    end
    # 作成済みのリンクを取得する
    def set_available_links_to_gon
      gon.available_links = Post.where(user_id: current_user.id).tags_on(:links).pluck(:name)
    end
    # 他のユーザーの編集ページへのアクセス拒否
    def correct_user
      @post = Post.find(params[:id])
      unless @post.user.id == current_user.id
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_path
      end
    end
end
