class Tweet < ActiveRecord::Base
  validates :user, :presence => true, :length => { :maximum => 138 } # I can't find out the maximum "earlybird" twitter name

  validates :tweeted_at, :presence => true

  validates :msg_twid, :numericality => { :only_integer => true, :greater_than => 0 }, :uniqueness => true

  # Originally I had maximum length of 140, but it can be longer:

  # tweet.raw_text = RT @twittelator: Imagine infusing your brain with a thousand cool ideas and software techniques in 50 hours w/ no sleep #iosdevcamp http://moby.to/zreow7, tweet.raw_text.size = 153

  # I have no idea what the maximum is, so I'll remove it for now.

  validates :raw_text, :presence => true

  scope :since_id, lambda {|id| { :conditions => ['msg_twid > ?', id] } }
end
