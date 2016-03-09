class PostsController < ApplicationController

  def index
    @tags = Post.tag_counts_on(:tags).most_used(15)

    if params[:q].nil?
      @search = Post.search(params[:q])
    else
      @search = Post.tagged_with(params[:q][:topik_cont], any: true).search('')
    end

    if params[:tag]
      @posts = Kaminari.paginate_array(Post.tagged_with(params[:tag]).order('created_at DESC')).page(params[:page]).per(3)
    else
      @posts = Kaminari.paginate_array(@search.result.order('created_at DESC')).page(params[:page]).per(3)
    end

  end

  def show
    @post = Post.find(params[:id])
    @comments = Kaminari.paginate_array(@post.comments.order('created_at DESC')).page(params[:page]).per(10)
  end

  def new
    @post = Post.new
  end

  def create
    if params[:file]
      if user_signed_in?
        cnt = params[:file].split(' ').length - 1
        if cnt > 0
          post_name = "Upload  #{cnt}  images"
          tag_list = 'upload, images'
          @post = current_user.posts.create(topik: post_name, content: params[:file], tag_list: tag_list)
          current_user.events.create(name: 'Upload imgs', eventable_content: @post.topik, eventable_id: @post.id, eventable_type: 'Post')
        end
      end
    else
      @post = current_user.posts.build(post_params)
  
      if @post.save
        current_user.events.create(name: 'Create post', eventable_content: @post.topik, eventable_id: @post.id, eventable_type: 'Post')
        redirect_to @post
      else
        flash[:alert] = 'Заполните поля!'
        redirect_to new_post_path
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      current_user.events.create(name: "Destroy post", eventable_content: @post.topik, eventable_id: @post.id, eventable_type: 'Post')
      redirect_to root_path
    end
  end

  private
  def post_params
    params.require(:post).permit(:topik, :content, :user_id, :tag_list)
  end

end
