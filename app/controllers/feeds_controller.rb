class FeedsController < ApplicationController
  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all
    all_feeds = []
    @feeds.each do |feed|
      rss = SimpleRSS.parse open(feed.url)
      all_feeds << rss.items
    end
    @rss_items = (all_feeds.flatten.sort_by { |k| k[:pubDate] }).reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])
    @rss = SimpleRSS.parse open(@feed.url)
    @rss_items = (@rss.items.sort_by { |k| k[:pubDate] }).reverse

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  rescue
    redirect_to feeds_url
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(params[:feed])

    respond_to do |format|
      if rss_validator && @feed.save
        format.html { redirect_to @feed, notice: 'Rss reader was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.json
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if rss_validator && @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, notice: 'Rss reader was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end

  protected()
  def rss_validator
    valid = false
    site_url = params[:feed][:url].sub(/(\/)+$/,'')
    begin
    v = W3C::FeedValidator.new
    if @feed.valid? && v.validate_url(site_url) && v.valid?
      valid = true
    end
    rescue
      flash[:error] = "Invalid feed url"
      valid = false
    end
  end
end
