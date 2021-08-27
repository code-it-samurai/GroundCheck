class GroundSportsMastersController < ApplicationController
  before_action :set_ground_sports_master, only: %i[ show edit update destroy ]

  # GET /ground_sports_masters or /ground_sports_masters.json
  def index
    @ground_sports_masters = GroundSportsMaster.all
  end

  # GET /ground_sports_masters/1 or /ground_sports_masters/1.json
  def show
  end

  # GET /ground_sports_masters/new
  def new
    @ground_sports_master = GroundSportsMaster.new
  end

  # GET /ground_sports_masters/1/edit
  def edit
  end

  # POST /ground_sports_masters or /ground_sports_masters.json
  def create
    @ground_sports_master = GroundSportsMaster.new(ground_sports_master_params)

    respond_to do |format|
      if @ground_sports_master.save
        format.html { redirect_to @ground_sports_master, notice: "Ground sports master was successfully created." }
        format.json { render :show, status: :created, location: @ground_sports_master }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ground_sports_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ground_sports_masters/1 or /ground_sports_masters/1.json
  def update
    respond_to do |format|
      if @ground_sports_master.update(ground_sports_master_params)
        format.html { redirect_to @ground_sports_master, notice: "Ground sports master was successfully updated." }
        format.json { render :show, status: :ok, location: @ground_sports_master }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ground_sports_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ground_sports_masters/1 or /ground_sports_masters/1.json
  def destroy
    @ground_sports_master.destroy
    respond_to do |format|
      format.html { redirect_to ground_sports_masters_url, notice: "Ground sports master was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ground_sports_master
      @ground_sports_master = GroundSportsMaster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ground_sports_master_params
      params.require(:ground_sports_master).permit(:ground_id, :sports_master_id)
    end
end
