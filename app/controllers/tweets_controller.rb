class TweetsController < ApplicationController
  before_filter :query_twitter, :only => :index
  
  # GET /tweets
  # GET /tweets.json
  def index
    chain = Tweet
    chain = chain.since_id(params[:since_id]) if params[:since_id]
    @tweets = chain.all(:order => 'msg_twid ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tweets }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tweet }
    end
  end

  private

  def query_twitter
    EyeDropr::Twitter.search_for_tag(params[:tag])
  end
end
