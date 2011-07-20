require 'open-uri'

module EyeDropr
  module Twitter
    TIME_BETWEEN_QUERIES = 5.seconds

    # Start with Objtive-C code fragment since it might be easier to
    # update if we grab the important pieces with a Regexp rather than
    # hacking them ourselves with a text-editor.
    #
    # Our code depends on http being the only protocol in the
    # Objective-C, but it creates a Ruby Regexp that matches both http
    # and https.

    source = <<-'EOS'
- (NSString *)twitPicUrlInURLS:(NSArray *)urls {
	for (NSString *twit in urls) {
		if ([twit hasPrefix:@"http://twitpic.com/"]
			|| [twit hasPrefix:@"http://movapic.com/pic"]
			|| [twit hasPrefix:@"http://pk.gd/"] 
			|| [twit hasPrefix:@"http://instagr.am/p"] 
			|| [twit hasPrefix:@"http://mp.gd/"] 
			|| [twit hasPrefix:@"http://mobypicture.com/?"]
			|| [twit hasPrefix:@"http://moby.to"]
			|| [twit hasPrefix:@"http://img.ly/"]
			|| [twit hasPrefix:@"http://twitgoo.com"]
			|| [twit hasPrefix:@"http://yfrog.com"]
			|| [twit hasPrefix:@"http://tweetphoto.com/"]
			|| [twit hasPrefix:@"http://plixi.com/"]
			|| [twit hasPrefix:@"http://lockerz.com/"]
			|| [twit hasPrefix:@"http://pic.gd/"]
			|| [twit hasPrefix:@"http://twitlens.com/?"]) return twit;
	}
	return nil;
}
    EOS
    quoted_paths = source.scan(%r{hasPrefix:@"http://(.*?)"}m).map do |p|
      Regexp.quote(p.first)
    end
    IMAGE_REGEXP = %r{(https?://(#{quoted_paths.join('|')}).*?)(\s|$)}.freeze

    class << self
      def search_for_tag(tag)
        Tweet.transaction do
          tag ||= 'iosdevcamp'
          rate_limited(Poll, :tag, tag) do |since_id|
            base_url = "http://search.twitter.com/search.json"
            url = base_url + "?tag=#{tag}&rpp=100"
            url << "&since_id=#{since_id}" if since_id
            done = false
            max_id = since_id
            until done
              uri_contents = open(url)
              hash = ActiveSupport::JSON.decode(uri_contents.read)
              if hash['error'] =~ /page.*out of range/i
                done = true
              else
                results = hash['results']
                max_id = hash['max_id'] || max_id
                if results.empty?
                  done = true
                else
                  if hash.has_key?('next_page')
                    url = base_url + hash['next_page']
                  else
                    done = true
                  end
                  for result in results
                    create_from_result(result)
                  end
                end
              end
            end
            max_id
          end
        end
      end

      private

      def rate_limited(model, attribute, value)
        most_recent = model.first(:conditions => ["#{attribute} = ?", value], :limit => 1, :order => 'updated_at DESC')
        if most_recent.nil? || most_recent.updated_at + TIME_BETWEEN_QUERIES < Time.now
          if most_recent
            most_recent.updated_at = DateTime.now
          else
            most_recent = model.new(attribute => value)
          end
          most_recent.max_id = yield(most_recent.max_id)
          most_recent.save!
        end
      end

      def image_extract(raw_text)
        raw_text =~ IMAGE_REGEXP
        image_url = $1
        if image_url
          shrunken_text = raw_text.sub(/\s*#{Regexp.quote(image_url)}\s*/, '')
        else
          shrunken_text = nil
        end
        return image_url, shrunken_text
      end

      def create_from_result(result)
        user, raw_text, msg_id, tweeted_at = result['from_user'], result['text'], result['id'], DateTime.parse(result['created_at'])
        image_url, text = image_extract(raw_text)
        if image_url
          begin
            # We want to silently ignore if we try to create a tweet
            # with the same msg_twid.  That can happen if we serve two
            # requests simultaneously.  If we wanted to be paranoid we
            # could check teh raw_text, since they should be exactly
            # the same.
            tweet = Tweet.create(:user => user,
                                 :tweeted_at => tweeted_at,
                                 :msg_twid => msg_id,
                                 :raw_text => raw_text,
                                 :text => text,
                                 :image_url => image_url)
            unless tweet.errors.empty? || tweet.errors.messages == {:msg_twid => ['has already been taken']}
              tweet.save! # This will raise an error
            end
          rescue PGError => e
              raise e unless e.message =~ /duplicate key value.*"index_tweets_on_msg_twid"/
          end
        end
      end
    end
  end
end
