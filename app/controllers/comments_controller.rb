class CommentsController < ApplicationController

  def create

    if params[:comment][:id] == '-1'
      @comment = current_user.comments.create(comment_params)
    else
      @comment = Comment.find(params[:comment][:id])
      @comment.update(comment_params)
    end

    current_user.events.create(name: 'Comment create', eventable_content: @comment.content,
                               eventable_id: @comment.id, eventable_type: 'Comment')
    @error_message = ''
    @page = params[:comment][:page]
    @post_id = params[:comment][:post_id]
    @comments = Kaminari.paginate_array(@comment.post.comments.order('created_at DESC')).page(@page).per(10)

    # @error_message = @comment.errors.full_messages.first
    respond_to do |format|
      format.js
    end
  end

  def comment_file

    if params[:comment][:id] == '-1'
      @comment = current_user.comments.create(comment_params)
    else
      @comment = Comment.find(params[:comment][:id])
    end
    @comment_id = @comment.id
    params[:files].each do |arr_file|
      p_file =  arr_file.last
      @file = {
          path: p_file.path,
          filename: p_file.original_filename,
          type: p_file.content_type,
          head: p_file.headers
      }
    Resque.enqueue(CommentFilesUpload, @comment_id, @file)
    end
    respond_to do |format|
      format.js
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    current_user.events.create(name: 'Comment destroy', eventable_content: @comment.content, eventable_id: @comment.id, eventable_type: 'Comment')

    @error_message = ''
    @page = params[:page].to_i
    @comments = Kaminari.paginate_array(@comment.post.comments.order('created_at DESC')).page(@page).per(10)

    respond_to do |format|
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:post_id, :user_id, :content)
  end

end