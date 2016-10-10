class Comment < ActiveRecord::Base
  belongs_to :entry, :counter_cache => true
  belongs_to :user  
  validates_length_of :body, :maximum => 1000
end
