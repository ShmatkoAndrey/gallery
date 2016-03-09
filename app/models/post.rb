class Post < ActiveRecord::Base

  acts_as_taggable

  belongs_to :user

  validates_presence_of :topik, :content, :user_id
  validates :topik, length: { maximum: 125 }
  # validates :content, length: { maximum: 10000 }

  has_many :comments, :dependent => :destroy
  has_many :events, :as => :eventable


end
