class FeedArticlesController < ApplicationController
  before_action :set_feed_article, only: [:show, :edit, :update, :destroy]

  # GET /feed_articles
  # GET /feed_articles.json
  def index
    @feed_articles = FeedArticle.all
  end

  # GET /feed_articles/1
  # GET /feed_articles/1.json
  def show
  end

  # GET /feed_articles/new
  def new
    @feed_article = FeedArticle.new
  end

  # GET /feed_articles/1/edit
  def edit
  end

  # POST /feed_articles
  # POST /feed_articles.json
  def create
    @feed_article = FeedArticle.new(feed_article_params)

    respond_to do |format|
      if @feed_article.save
        format.html { redirect_to @feed_article, notice: 'Feed article was successfully created.' }
        format.json { render :show, status: :created, location: @feed_article }
      else
        format.html { render :new }
        format.json { render json: @feed_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feed_articles/1
  # PATCH/PUT /feed_articles/1.json
  def update
    respond_to do |format|
      if @feed_article.update(feed_article_params)
        format.html { redirect_to @feed_article, notice: 'Feed article was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed_article }
      else
        format.html { render :edit }
        format.json { render json: @feed_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_articles/1
  # DELETE /feed_articles/1.json
  def destroy
    @feed_article.destroy
    respond_to do |format|
      format.html { redirect_to feed_articles_url, notice: 'Feed article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed_article
      @feed_article = FeedArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_article_params
      params.require(:feed_article).permit(:feed_id, :guid, :published_at, :data)
    end
end
