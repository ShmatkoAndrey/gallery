class Comment < ActiveRecord::Base
  belongs_to :post, touch: true
  belongs_to :user

  # validates_presence_of :post_id, :user_id, :content
  # validates :content, length: { maximum: 5000 }

  has_many :events, :as => :eventable
  has_many :files_comments, dependent: :destroy

end
