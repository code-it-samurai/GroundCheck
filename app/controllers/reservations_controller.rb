require 'date'
require 'time'
class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit update destroy ]

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations or /reservations.json
  def create
    # PARSING AND CONFIGURING FOR SUITABLE STORAGE FORMAT
    # DATE
    received_date, received_time = params[:date_time].split("=")
    received_time = received_time.split("-")[0]

    # TIME
    processed_date = Date.parse(received_date)
    processed_start_time, processed_finish_time = received_time.split("to")
    processed_start_time = Time.parse("#{processed_start_time} #{processed_date}").to_i
    processed_finish_time = Time.parse("#{processed_finish_time} #{processed_date}").to_i
        
    # USER
    res_user_id = params[:user_id]

    # GROUND
    res_ground_id = params[:ground_id]

    # ACTIVITY
    sports_master_record = SportsMaster.where(name: params[:selected_activity])[0]
    reservation_sports_master_id = sports_master_record.id
    reservation_cost = params[:cost]

    # COLLECTING ALL CONFIGURED PARAMS
    reservation_info = {:date => processed_date, :user_id => res_user_id, :ground_id => res_ground_id, :sports_master_id => reservation_sports_master_id, :starting_time => processed_start_time, :finishing_time => processed_finish_time, :cost => reservation_cost}
    @ground = Ground.find(res_ground_id)
    @reservation = Reservation.new(reservation_info)    
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to root_path, notice: "Reservation was successfully created. Refresh to see latest updates on your reservations." }
      else
        format.html { redirect_to root_path, notice: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:date, :user_id, :ground_id, :sports_master_id, :starting_time, :finishing_time, :cost)
    end
end
