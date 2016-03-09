module CommentsHelper
  def split_comment_images(comment)

    mass = [[],[]]
    formats = ["jpg","jpeg","png","gif"]

    comment.files_comments.each do |file|
      format = file.file_identifier.split(".").last

      if formats.any? {|f| f==format}
        mass[0] << file.file.url
      else
        mass[1] << file
      end

    end
    mass
  end
end