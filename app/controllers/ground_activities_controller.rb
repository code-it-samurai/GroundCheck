class GroundActivitiesController < ApplicationController
  before_action :set_ground_activity, only: %i[ show edit update destroy ]

  # GET /ground_activities or /ground_activities.json
  def index
    @ground_activities = GroundActivity.all
  end

  # GET /ground_activities/1 or /ground_activities/1.json
  def show
  end

  # GET /ground_activities/new
  def new
    @ground_activity = GroundActivity.new
  end

  # GET /ground_activities/1/edit
  def edit
  end

  # POST /ground_activities or /ground_activities.json
  def create
    @ground_activity = GroundActivity.new(ground_activity_params)

    respond_to do |format|
      if @ground_activity.save
        format.html { redirect_to @ground_activity, notice: "Ground activity was successfully created." }
        format.json { render :show, status: :created, location: @ground_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ground_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ground_activities/1 or /ground_activities/1.json
  def update
    respond_to do |format|
      if @ground_activity.update(ground_activity_params)
        format.html { redirect_to @ground_activity, notice: "Ground activity was successfully updated." }
        format.json { render :show, status: :ok, location: @ground_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ground_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ground_activities/1 or /ground_activities/1.json
  def destroy
    @ground_activity.destroy
    respond_to do |format|
      format.html { redirect_to ground_activities_url, notice: "Ground activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ground_activity
      @ground_activity = GroundActivity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ground_activity_params
      params.require(:ground_activity).permit(:ground_id, :sports_master_id)

    end
end
