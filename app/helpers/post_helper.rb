module PostHelper
  def comments_count(post)
    post.comments.all.size
  end
end