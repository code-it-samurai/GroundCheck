require 'date'
class GroundsController < ApplicationController
  before_action :set_ground, only: %i[ show edit update destroy ]

  # GET /grounds or /grounds.json
  def index
    @grounds = Ground.all
  end

  def get_all_available_activities_objects
    all_activities = []
    all_activity_objects = SportsMaster.all
    all_activity_objects.each do |activity_obj|
      all_activities.append(activity_obj)
    end
    return all_activities
  end

  def get_all_available_activities
    all_activities = []
    all_activity_objects = SportsMaster.all
    all_activity_objects.each do |activity_obj|
      all_activities.append(activity_obj.name)
    end
    return all_activities
  end

  # GET /grounds/1 or /grounds/1.json
  def show
    @allsportsmasters = get_all_available_activities_objects()
    # GET ACTIVITIES AVAILABLE AT GROUND
    @current_ground_id = params[:id]
    @current_ground_activities = []
    GroundSportsMaster.where(ground_id: @current_ground_id).find_each do |ground_sports_masters_object|
      activity_id = ground_sports_masters_object[:sports_master_id]
      @current_ground_activities.append(SportsMaster.find(activity_id).name)
    end 

    # GET DATES AVAILABLE
    days_for_reservation = 2
    max_number_of_hours_in_a_slot = 2

    # we only want slots of 1 hours but the indexing will start from 0
    # 0th index is ignored because it cannot be used for addition of an hour in "time"
    # so thats why its 2.times

    @current_ground_available_dates = []
    todays_date = Date.today
    days_for_reservation.times do |days_from_today|
      newdate = todays_date + days_from_today
      @current_ground_available_dates.append(newdate.strftime("%d/%m/%Y"))
    end

    # GET AVAILABLE TIME SLOTS
    @available_time_slots = []
    @available_time_slots_4_2weeks = {}
    # hours
    opening_hour = @ground.opening_time.hour
    closing_hour = @ground.closing_time.hour

    opening_time = Time.parse("#{opening_hour}:00 #{todays_date} ")
    closing_time = Time.parse(" #{closing_hour}:00 #{todays_date}")
    @open_time = opening_time.strftime("%I:%M %p")
    @close_time = closing_time.strftime("%I:%M %p")


    slot_starting_hour = opening_hour
    today_date = Date.today
    days_for_reservation.times do |day|

      dropdown_display_date = today_date.strftime("%d %B %Y on %A")
      #appending the display date inside the dropdown
      @available_time_slots.append(dropdown_display_date)

      # while slot starting hour is less than the closing hour
      while slot_starting_hour < closing_hour

        
        max_number_of_hours_in_a_slot.times do |hour|
          slot_finishing_hour = slot_starting_hour + hour

          #ignoring the 0 index
          if hour == 0
            next
          end

          # if finishing hour is less than or equial to closing hour we are good
          if slot_finishing_hour <= closing_hour and slot_finishing_hour <= slot_starting_hour + 1
            @available_time_slots.append("#{slot_starting_hour}:00 = #{slot_finishing_hour}:00 = (#{hour} HOUR)")
          end
        end
        slot_starting_hour = slot_starting_hour + 1
      end
      slot_starting_hour = opening_hour
      today_date = today_date + 1
    end

    # @available_time_slots holds all the time slots that can be available for 2 days
    # @current_ground_booked_slots_hash holds all the time slots that are booked in key value format {activity_name: [slots]}
    # @current_ground_available_slots_hash holds all the time slots that CAN be booked in a key value format {activity_name: [slots]}

    # DATE FILTRATION

    @current_ground_booked_slots_hash = {}
    # @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmaster_object|
      #collect all of the reservations which are made for current ground
      reservations = Reservation.where(ground_id: @current_ground_id, sports_master_id:sportsmaster_object.id)
      slots_4_current_activity = []

      # collect all the reservations for current ground which are not inactive in a hash where keys are activity names and values are arrays of available time slots for available time slots
      reservations.each do |reservation_for_current_ground|
        if reservation_for_current_ground.status != INACTIVE_STATUS
          slots_4_current_activity.append("#{Time.at(reservation_for_current_ground.starting_time)} = #{Time.at(reservation_for_current_ground.finishing_time)}")
        end
      end
      @current_ground_booked_slots_hash[sportsmaster_object.name] = slots_4_current_activity
    end

    @current_ground_available_slots_hash = {}
    # @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmaster_object|
      @current_ground_available_slots_hash[sportsmaster_object.name] = []      
    end

    # @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmaster_object|
      # day is a variable used to index available dates out of an array it starts with -1 
      # because the very first value in a drop down is going to be a date which increments day
      # and since indexes start with 0 the variable is initialized as -1 to later start as 0
      # when its increments in the very first loop

      day = -1
      @available_time_slots.each do |slot|
        if(slot.include?"on")
            @current_ground_available_slots_hash[sportsmaster_object.name].append(slot)
            day = day + 1
            next
        end
        processed_start_time, processed_finish_time = slot.split("=")
        processed_start_time = Time.parse("#{processed_start_time} #{@current_ground_available_dates[day]}")
        processed_finish_time = Time.parse("#{processed_finish_time} #{@current_ground_available_dates[day]}")
        @current_ground_available_slots_hash[sportsmaster_object.name].append("#{processed_start_time} = #{processed_finish_time}")
      end
    end

    # Delete all the available slots that match with booked slots
    @allsportsmasters.each do |sportsactivity|
      @current_ground_booked_slots_hash[sportsactivity.name].each do |booked_slot|
        @current_ground_available_slots_hash[sportsactivity.name].each do |available_slot|
          if available_slot == booked_slot
            @current_ground_available_slots_hash[sportsactivity.name].delete(booked_slot)
          end
        end
      end
    end

    # formatting the filtered out slots for display purpose
    @display_avail_times = []
    @ground_available_reservations = {}
    # ----------------------------------------------------------

    # initializing an empty hash for formatted values for UI display
    @allsportsmasters.each do |sportsmaster_object|
      @ground_available_reservations[sportsmaster_object.name] = []
    end

    @allsportsmasters.each do |asm|
      @current_ground_available_slots_hash[asm.name].each do |available_slot|
        if available_slot.include?"on"
          @ground_available_reservations[asm.name].append(available_slot)
          next
        end
        start, finish = available_slot.split("=")
        start = Time.parse(start).hour
        finish = Time.parse(finish).hour
        @ground_available_reservations[asm.name].append("#{start}:00 to #{finish}:00")
      end
    end

    # CHECK IF CURRENT USER IS OWNER OF THIS GROUND
    if @ground.user_id == current_user.id
      @user_owns_this_ground = true
    else
      @user_owns_this_ground = false
    end

    # CHECK IF CURRENT USER HAS THIS GROUND IN HIS/HER FAVORITES LIST
    user_sports_master_for_ground = UserSportsMaster.where(ground_id: @ground.id, user_id: current_user.id)
    if user_sports_master_for_ground.length > 0
      @favorite = true
    else
      @favorite = false
    end
  end

  # GET /grounds/new
  def new
    @ground = Ground.new
    @all_activities = get_all_available_activities()
  end

  # GET /grounds/1/edit
  def edit
    @sus_user = false
    @current_ground_obj = Ground.find(params[:id])
    if !current_user.ground_owner
      @sus_user = true
    elsif current_user.id != @current_ground_obj.user_id
      @sus_user = true
    end
    ground_sports_master = GroundSportsMaster.where(ground_id: @ground.id)
    @available_activities = []
    ground_sports_master.each do |ground_sports_master_object|
      activity_name = SportsMaster.find(ground_sports_master_object.sports_master_id).name
      @available_activities.append(activity_name)
    end
    @all_activities = get_all_available_activities()
  end

  # POST /grounds or /grounds.json
  def create
    @ground = Ground.new(ground_params)

    #manually saving values that are delivered in array format or need some formating before being inserted
    @ground.opening_time = Time.parse("#{@ground.opening_time.hour}:00")
    @ground.closing_time = Time.parse("#{@ground.closing_time.hour}:00")
    @ground_owner = User.find(ground_params[:user_id])
    @ground_owner.ground_owner = true
    @ground_owner.save
    @ground.save
    activities = params[:ground][:sports_activities]
    if activities 
      activities.each do |activity|
        @sports_master = SportsMaster.where(name:activity)[0]
        @groundsportsmaster = GroundSportsMaster.new()
        @groundsportsmaster.ground_id = @ground.id
        @groundsportsmaster.sports_master_id = @sports_master[:id]
        # if GroundSportsMaster.where(ground_id: @ground.id, sports_master_id: @sports_master.id).length == 0
          @groundsportsmaster.save    
        # end
      end
    end

    respond_to do |format|
      if @ground.save
        format.html { redirect_to @ground, notice: "Ground was successfully created." }
        format.json { render :show, status: :created, location: @ground }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ground.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grounds/1 or /grounds/1.json
  def update
    activities = params[:ground][:sports_activities]
    # UPDATING JUNCITON TABLE
    GroundSportsMaster.where(ground_id: params[:id]).delete_all
    if activities 
      activities.each do |activity|
        @sports_master = SportsMaster.where(name:activity)[0]
        @groundsportsmaster = GroundSportsMaster.new()
        @groundsportsmaster.ground_id = @ground.id
        @groundsportsmaster.sports_master_id = @sports_master[:id]
        if GroundSportsMaster.where(ground_id: @ground.id, sports_master_id: @sports_master.id).length == 0
          @groundsportsmaster.save    
        end
      end
    end
    respond_to do |format|
      if @ground.update(ground_params)
        format.html { redirect_to @ground, notice: "Ground was successfully updated." }
        format.json { render :show, status: :ok, location: @ground }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ground.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grounds/1 or /grounds/1.json
  def destroy
    @ground.destroy
    respond_to do |format|
      format.html { redirect_to grounds_url, notice: "Ground was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ground
      @ground = Ground.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ground_params
      params.require(:ground).permit(:user_id, :ground_name, :ground_pincode, :business_email, :business_phone, :cost_per_hour, :opening_time, :closing_time, :location)
    end
end
