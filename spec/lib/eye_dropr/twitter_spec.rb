require 'spec_helper'

# NOTE: We need to test more functionality.

describe EyeDropr::Twitter do
  describe 'search_for_tag' do
    before(:each) do
      @first_page_uri = 'http://search.twitter.com/search.json?tag=iosdevcamp&rpp=100'
      @last_page_uri = 'http://search.twitter.com/search.json?page=2&max_id=92684748165623808&rpp=100&q=+%23iosdevcamp'
    end
    it 'searches' do
      EyeDropr::FakeHelper.register(@first_page_uri => :first_page,
                                    @last_page_uri => :last_page)
      EyeDropr::Twitter.search_for_tag('iosdevcamp')
    end

    it 'finishes if we get a page out of range' do
      EyeDropr::FakeHelper.register(@first_page_uri => :out_of_range)
      EyeDropr::Twitter.search_for_tag('iosdevcamp')
    end

    it 'finishes if we get no results' do
      EyeDropr::FakeHelper.register(@first_page_uri => :empty_results)
      EyeDropr::Twitter.search_for_tag('iosdevcamp')
    end
  end

  describe 'rate_limited' do
    it "updates updated_at if there's an existing record" do
      poll = mock_model(Poll, :updated_at => Time.now - EyeDropr::Twitter::TIME_BETWEEN_QUERIES,
                        :max_id => 12345)
      value = 123456
      poll.should_receive(:updated_at=)
      poll.should_receive(:max_id=).with(value)
      poll.should_receive(:save!)
      EyeDropr::Twitter.instance_eval do
        Poll.should_receive(:first).and_return(poll)
        rate_limited(Poll, :tag, :ignored) do
          value
        end
      end
    end
  end

  describe 'create_from_result' do
    before(:each) do
      result = {
        'from_user' => 'csedda',
        'text' => 'RT @xdamman: Storify proud sponsor of #iosdevcamp http://instagr.am/p/Hz-Ma/',
        'id' => '92499662870814720',
        'created_at' => '2011-07-17 07:43:32'
      }
      @invoke = -> { 
        EyeDropr::Twitter.instance_eval do
          create_from_result(result)
        end
      }
    end

    it 'raises an error if create returns an error' do
      tweet = mock_model(Tweet)
      Tweet.should_receive(:create).and_return(tweet)
      tweet.errors.should_receive(:empty?).and_return(false)
      tweet.should_receive(:save!)
      @invoke.call
    end

    it 'raises on PGError' do
      Tweet.should_receive(:create).and_raise(PGError)
      lambda {
        @invoke.call
      }.should raise_error(PGError)
    end
  end
end
