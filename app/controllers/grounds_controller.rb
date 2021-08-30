require 'date'
class GroundsController < ApplicationController
  before_action :set_ground, only: %i[ show edit update destroy ]

  # GET /grounds or /grounds.json
  def index
    @grounds = Ground.all
  end

  # GET /grounds/1 or /grounds/1.json
  def show
    # GET AVAILABLE ACTIVITIES
    @current_ground_id = params[:id]
    @current_ground_activities = []
    GroundSportsMaster.where(ground_id: @current_ground_id).find_each do |record|
      activity_id = record[:sports_master_id]
      @current_ground_activities.append(SportsMaster.find(activity_id).name)
    end 

    # GET AVAILAVLE DATES
    days_for_reservation = 6
    max_number_of_hours_in_a_slot = 4
    @current_ground_available_dates = []
    todays_date = Date.today
    days_for_reservation.times do |days_from_today|
      newdate = todays_date + days_from_today
      @current_ground_available_dates.append(newdate.strftime("%d/%m/%Y"))
    end

    # GET AVAILABLE TIME SLOTS
    @available_time_slots = []
    @available_time_slots_4_2weeks = {}
    days_for_reservation= 2
    max_number_of_hours_in_a_slot = 2
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

        #we only want slots of 1 hours but the indexing will start from 0 s 
        # so thats why its 2.times
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

    # DATE FILTRATION
    @all_active_activity_res = {}
    @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmasterobj|
      reservations = Reservation.where(ground_id: @current_ground_id, status: "active", sports_master_id:sportsmasterobj.id)
      slots_4_current_activity = []
      reservations.each do |myres|
        slots_4_current_activity.append("#{Time.at(myres.starting_time)} = #{Time.at(myres.finishing_time)}")
      end
      @all_active_activity_res[sportsmasterobj.name] = slots_4_current_activity
    end


    

    # getting reserved slots for current ground
    reservations = Reservation.where(ground_id: @current_ground_id, status: "active")
    @reserve_times = []
    reservations.each do |reserve|
      @reserve_times.append("#{Time.at(reserve.starting_time)} = #{Time.at(reserve.finishing_time)}")
    end

    #formatting all the dates for this ground
    @avail_times = []
    day = -1
    @available_time_slots.each do |slot|
      if(slot.include?"on")
          @avail_times.append(slot)
          day = day + 1
          next
      end
      processed_start_time, processed_finish_time = slot.split("=")
      processed_start_time = Time.parse("#{processed_start_time} #{@current_ground_available_dates[day]}")
      processed_finish_time = Time.parse("#{processed_finish_time} #{@current_ground_available_dates[day]}")
      @avail_times.append("#{processed_start_time} = #{processed_finish_time}")
    end

    @all_activity_res = {}
    @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmasterobj|
      @all_activity_res[sportsmasterobj.name] = []      
    end

    @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmasterobj|
      day = -1
      @available_time_slots.each do |slot|
        if(slot.include?"on")
            @avail_times.append(slot)
            @all_activity_res[sportsmasterobj.name].append(slot)
            day = day + 1
            next
        end
        processed_start_time, processed_finish_time = slot.split("=")
        processed_start_time = Time.parse("#{processed_start_time} #{@current_ground_available_dates[day]}")
        processed_finish_time = Time.parse("#{processed_finish_time} #{@current_ground_available_dates[day]}")
        @avail_times.append("#{processed_start_time} = #{processed_finish_time}")
        @all_activity_res[sportsmasterobj.name].append("#{processed_start_time} = #{processed_finish_time}")
      end
      # @all_activity_res[sportsmasterobj.name] = @avail_times
    end

    # removing available dates which match with reserved dates
    # @match_times = []
    # @reserve_times.each do |rt|
    #   @avail_times.each do |at|
    #     if rt == at
    #       @match_times.append(rt)
    #       @avail_times.delete(rt)
    #     end
    #   end
    # end

    @all_conflict = []
    @allsportsmasters.each do |asm|
      @all_active_activity_res[asm.name].each do |aaar|
        @all_activity_res[asm.name].each do |aar|
          if aar == aaar          
            @all_conflict.append(aaar)
            @all_activity_res[asm.name].delete(aaar)
          end
        end
      end
    end

    # formatting the filtered out slots for display purpose
    @display_avail_times = []
    # @avail_times.each do |at|
    #   if at.include?"on"
    #     @display_avail_times.append(at)
    #     next
    #   end
    #   start, finish = at.split("=")
    #   start = Time.parse(start).hour
    #   finish = Time.parse(finish).hour
    #   @display_avail_times.append("#{start}:00 to #{finish}:00")
    # end
    @display_activity_res = {}
    @allsportsmasters = SportsMaster.all
    @allsportsmasters.each do |sportsmasterobj|
      @display_activity_res[sportsmasterobj.name] = []
    end

    @allsportsmasters.each do |asm|
      @all_activity_res[asm.name].each do |aar|
        if aar.include?"on"
          @display_activity_res[asm.name].append(aar)
          next
        end
        start, finish = aar.split("=")
        start = Time.parse(start).hour
        finish = Time.parse(finish).hour
        @display_activity_res[asm.name].append("#{start}:00 to #{finish}:00")
      end
    end

    if @ground.user_id == current_user.id
      @user_owns_this_ground = true
    else
      @user_owns_this_ground = false
    end

    usm_4_ground = UserSportsMaster.where(ground_id: @ground.id)
    usm_4_ground.each do |usm4ground|
      if usm4ground.user_id == current_user.id
        @favorite = true
      else
        @favorite = false
      end
    end
  end

  # GET /grounds/new
  def new
    @ground = Ground.new
    @all_activities = ['Football', 'Basket Ball', 'Cricket', 'Chess', 'Volley Ball', 'Table Tennis', 'Tennis', 'Badminton']
  end

  # GET /grounds/1/edit
  def edit
    ground_sports_master = GroundSportsMaster.where(ground_id: @ground.id)
    @available_activities = []
    ground_sports_master.each do |gsm|
      activity_name = SportsMaster.find(gsm.sports_master_id).name
      @available_activities.append(activity_name)
    end
    # @ground[:sports_activities] = @available_activities
    @all_activities = ['Football', 'Basket Ball', 'Cricket', 'Chess', 'Volley Ball', 'Table Tennis', 'Tennis', 'Badminton']
  end

  # POST /grounds or /grounds.json
  def create
    # render plain: "#{ground_params[:opening_time]}"
    @ground = Ground.new(ground_params)
    @ground.opening_time = Time.parse("#{@ground.opening_time.hour}:00")
    @ground.closing_time = Time.parse("#{@ground.closing_time.hour}:00")
    # render plain: "#{@ground.opening_time}"
    @ground.save
    activities = params[:ground][:sports_activities]
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
    # @ground.update(ground_params)
    activities = params[:ground][:sports_activities]
    
    # render plain: "#{params}"
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

  def groundprofile
    if(user_signed_in)
      @current_user_id = current_user.id
      @ground_profile = Ground.find(@current_user_id)
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
