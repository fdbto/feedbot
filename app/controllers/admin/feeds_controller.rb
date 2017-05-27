class Admin::FeedsController < Admin::BaseController
  before_action :set_user
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /cron_jobs
  # GET /cron_jobs.json
  def index
    @feeds = @user.feeds.recently_posted.page(params[:page])
  end

  # GET /cron_jobs/1
  # GET /cron_jobs/1.json
  def show
  end

  # GET /cron_jobs/1/edit
  def edit
  end

  # PATCH/PUT /cron_jobs/1
  # PATCH/PUT /cron_jobs/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to [:admin, @user, :feeds], notice: 'Cron job was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cron_jobs/1
  # DELETE /cron_jobs/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @user, :feeds], notice: 'Cron job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.find params[:user_id]
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = @user.feeds.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feed_params
    params.require(:feed).permit(:url)
  end
end
