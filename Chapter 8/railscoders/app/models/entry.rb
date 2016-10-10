class Entry < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  has_many :comments
  validates_length_of :title, :maximum => 255
  validates_length_of :body, :maximum => 10000
end
