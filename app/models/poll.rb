class Poll < ActiveRecord::Base
  validates :tag, :presence => true, :allow_blank => false
  validates :max_id, :numericality => { :only_integer => true, :greater_than => 0, :allow_nil => true }
end
