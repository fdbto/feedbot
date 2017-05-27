class Admin::CronJobsController < Admin::BaseController
  before_action :set_cron_job, only: [:show, :edit, :update, :destroy]

  # GET /cron_jobs
  # GET /cron_jobs.json
  def index
    @cron_jobs = CronJob.all
  end

  # GET /cron_jobs/1
  # GET /cron_jobs/1.json
  def show
  end

  # GET /cron_jobs/new
  def new
    @cron_job = CronJob.new
  end

  # GET /cron_jobs/1/edit
  def edit
  end

  # POST /cron_jobs
  # POST /cron_jobs.json
  def create
    @cron_job = CronJob.new(cron_job_params)

    respond_to do |format|
      if @cron_job.save
        format.html { redirect_to [:admin, @cron_job], notice: 'Cron job was successfully created.' }
        format.json { render :show, status: :created, location: @cron_job }
      else
        format.html { render :new }
        format.json { render json: @cron_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cron_jobs/1
  # PATCH/PUT /cron_jobs/1.json
  def update
    respond_to do |format|
      if @cron_job.update(cron_job_params)
        format.html { redirect_to [:admin, @cron_job], notice: 'Cron job was successfully updated.' }
        format.json { render :show, status: :ok, location: @cron_job }
      else
        format.html { render :edit }
        format.json { render json: @cron_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cron_jobs/1
  # DELETE /cron_jobs/1.json
  def destroy
    @cron_job.destroy
    respond_to do |format|
      format.html { redirect_to admin_cron_jobs_url, notice: 'Cron job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cron_job
    @cron_job = CronJob.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cron_job_params
    params.require(:cron_job).permit(:name, :schedule, :command, :next_run_at, :enabled, :description)
  end
end
