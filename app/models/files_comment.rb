class FilesComment < ActiveRecord::Base

  belongs_to :comment

  mount_uploader :file, CommentFileUploader

end
