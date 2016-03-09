class CommentFilesUpload
  @queue = :file_serve
  # run server:
  # rake resque:work QUEUE='*' TERM_CHILD=1
  def self.perform(comment_id, file )
    file = {
        tempfile: File.new(file['path']),
        filename: file['filename'],
        type: file['type'],
        head: file['head']
    }
    print "start save at #{DateTime.now.strftime('%I:%M:%S')}".gray
    @file_comment = FilesComment.create(comment_id: comment_id, file: ActionDispatch::Http::UploadedFile.new(file))
    print " -- save file ##{@file_comment.id} for comment #{comment_id} -- ".bold
    puts "at #{DateTime.now.strftime('%I:%M:%S')}".gray
  end
end