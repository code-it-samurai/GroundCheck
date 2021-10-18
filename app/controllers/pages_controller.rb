require 'time'
class PagesController < ApplicationController
	
	def home
		# SEND DATA IF SIGNED IN
		if(user_signed_in?)
			@current_user_reservations = []
			@current_user_interests = []
			@active = ACTIVE_STATUS
			@inactive = INACTIVE_STATUS
			@play_on = PLAY_ON_STATUS
			@checked_in = CHECKED_IN_STATUS
			@hour_left = HOUR_LEFT_STATUS
			# FINDING AND STORING INTERESTS
			begin
				UserSportsMaster.where(user_id: current_user.id).find_each do |user_sports_master_object|
					activity_id = user_sports_master_object[:sports_master_id]
					if activity_id
						@current_user_interests.append(SportsMaster.find(activity_id).name)
					end
				end
			rescue
				@current_user_reservations = nil
			end
			# Reservation Status Update
			
			def update_user_reservation_status(userid)
				# UPDATE USER RESERVATIONS STATUS
				Reservation.where(user_id: userid).find_each do |reservation_object|
					@current_date_time = Time.now
					res_starting_time = Time.at(reservation_object.starting_time)
					res_finishing_time = Time.at(reservation_object.finishing_time)
					starting_time_minus_hour = Time.parse("#{res_starting_time.hour - 1}:#{res_starting_time.min} #{res_starting_time.strftime("%d/%m/%Y")}")

					# saving boolean values of conditions for all the statuses
					inactive_conditions = res_finishing_time < @current_date_time and (reservation_object.status == ACTIVE_STATUS or reservation_object.status == HOUR_LEFT_STATUS or reservation_object.status == PLAY_ON_STATUS or reservation_object.status == CHECKED_IN_STATUS )
					play_on_conditions = res_starting_time < @current_date_time and res_finishing_time > @current_date_time and (reservation_object.status == ACTIVE_STATUS or reservation_object.status == HOUR_LEFT_STATUS)
					hour_left_condidions = starting_time_minus_hour < @current_date_time and reservation_object.status == ACTIVE_STATUS
					other_than_inactive_conditions = reservation_object.status != INACTIVE_STATUS

					# case is true because when a condition is true it will make a match and execute the code
					case true
					when inactive_conditions
						deactivate_reservation = Reservation.find(reservation_object.id)
						deactivate_reservation.update({:status => INACTIVE_STATUS})
					when play_on_conditions
						play_on_reservation = Reservation.find(reservation_object.id)										
						play_on_reservation.update({:status => PLAY_ON_STATUS})
						ground_name = Ground.find(reservation_object[:ground_id]).ground_name
						activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
						@current_user_reservations.append({:obj => reservation_object,:status => PLAY_ON_STATUS, :ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].to_formatted_s(:short),:reserved_activity => activity_name})						
					when hour_left_condidions
						hour_left_reservation = Reservation.find(reservation_object.id)
						hour_left_reservation.update({:status => HOUR_LEFT_STATUS})
						ground_name = Ground.find(reservation_object[:ground_id]).ground_name
						activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
						@current_user_reservations.append({:obj => reservation_object, :status => HOUR_LEFT_STATUS, :ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].to_formatted_s(:short),:reserved_activity => activity_name})
					when other_than_inactive_conditions
						random_reservation = Reservation.find(reservation_object.id)
						ground_name = Ground.find(reservation_object[:ground_id]).ground_name
						activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
						@current_user_reservations.append({:obj => reservation_object, :status =>reservation_object.status, :ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].to_formatted_s(:short),:reserved_activity => activity_name})											
					end						
				end	
			end

			update_user_reservation_status(current_user.id);

			def update_reservation_status(reservation_object)
				@current_date_time = Time.now
				res_starting_time = Time.at(reservation_object.starting_time)
				res_finishing_time = Time.at(reservation_object.finishing_time)
				starting_time_minus_hour = Time.parse("#{res_starting_time.hour - 1}:#{res_starting_time.min} #{res_starting_time.strftime("%d/%m/%Y")}")
				if res_finishing_time < @current_date_time and (reservation_object.status == ACTIVE_STATUS or reservation_object.status == HOUR_LEFT_STATUS or reservation_object.status == PLAY_ON_STATUS or reservation_object.status == CHECKED_IN_STATUS)
					status = INACTIVE_STATUS
				elsif starting_time_minus_hour < @current_date_time and reservation_object.status == ACTIVE_STATUS
					status = HOUR_LEFT_STATUS
				elsif res_starting_time < @current_date_time and res_finishing_time > @current_date_time and (reservation_object.status == ACTIVE_STATUS or reservation_object.status == HOUR_LEFT_STATUS or reservation_object.status == CHECKED_IN_STATUS)
					status = PLAY_ON_STATUS
				else
					status = ACTIVE_STATUS
				end						

				case status

				when INACTIVE_STATUS
					deactivate_reservation = Reservation.find(reservation_object.id)
					deactivate_reservation.update({:status => INACTIVE_STATUS})

				when HOUR_LEFT_STATUS
					hour_left_reservation = Reservation.find(reservation_object.id)
					hour_left_reservation.update({:status => HOUR_LEFT_STATUS})

				when PLAY_ON_STATUS
					play_on_reservation = Reservation.find(reservation_object.id)										
					play_on_reservation.update({:status => PLAY_ON_STATUS})
				end
			end

			if current_user.ground_owner
				@owned_ground_reservations = []
				@owned_ground = Ground.where(user_id: current_user.id)[0]
				Reservation.where(ground_id:@owned_ground[:id]).find_each do |rsg|
					# UPDATE RESERVATION STATUS 
					update_reservation_status(rsg)
					if(rsg.status != INACTIVE_STATUS)
						username = User.find(rsg.user_id).name
						activity_name = SportsMaster.find(rsg[:sports_master_id]).name
						@owned_ground_reservations.append({:obj => rsg,:username => username,:startingtime => Time.at(rsg[:starting_time]).strftime("%I:%M %p"), :finishingtime => Time.at(rsg[:finishing_time]).strftime("%I:%M %p"),:reservation_date => rsg[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name})
					end
				end
			end	
		end
	end

	def about
		
	end

	def reservation_history
		# 1 get ground and user details from collected IDs
		# 2 fill information into a hash with labeled keys
		# 3 save hashes for every reservation for user/ground array

		# if sus_user is true then the page is being accessed by unauthorized user
		@sus_user = false
		if params[:history_for] == "ground"
			if params[:ground_id] == nil
				redirect_to root_path, notice:"Unauthorized Access"
			else
				current_ground_obj = Ground.find(params[:ground_id])
				if !current_user.ground_owner
					@sus_user = true
				elsif current_user.id != current_ground_obj.user_id
					@sus_user = true
				end
			end
		end

		# HISTORY FOR USER
		if(params[:history_for] == "user")
			@active_reservations_history =[]
			@inactive_reservations_history = []
			Reservation.where(user_id: current_user.id).find_each do |reservation_object|
				if reservation_object[:status] == ACTIVE_STATUS or reservation_object[:status] == HOUR_LEFT_STATUS or reservation_object[:status] == PLAY_ON_STATUS or reservation_object[:status] == CHECKED_IN_STATUS
					ground_object = Ground.find(reservation_object[:ground_id])
					ground_name = ground_object.ground_name
					activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
					reservation_info = {:history_for => "user",:ground_obj => ground_object,:obj => reservation_object,:ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reservation_object[:created_at].strftime("%d/%m/%Y")}
					if reservation_object[:cost] != nil
						reservation_info[:cost]= reservation_object[:cost]
					end
					@active_reservations_history.append(reservation_info)
				elsif reservation_object[:status] == INACTIVE_STATUS
					ground_object = Ground.find(reservation_object[:ground_id])
					ground_name = ground_object.ground_name
					activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
					reservation_info = {:history_for => "user",:ground_obj => ground_object,:obj => reservation_object,:ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reservation_object[:created_at].strftime("%d/%m/%Y")}
					if reservation_object[:cost] != nil
						reservation_info[:cost]= reservation_object[:cost]
					end
					@inactive_reservations_history.append(reservation_info)
				end
			end
		# HISTORY FOR GROUND
		elsif params[:history_for] == "ground"
			@active_reservations_history =[]
			@inactive_reservations_history = []
			@current_ground_id = params[:ground_id]
			Reservation.where(ground_id: @current_ground_id).find_each do |reservation_object|
				if reservation_object[:status] == ACTIVE_STATUS or reservation_object[:status] == HOUR_LEFT_STATUS or reservation_object[:status] == PLAY_ON_STATUS or reservation_object[:status] == CHECKED_IN_STATUS
					username = User.find(reservation_object[:user_id]).username
					ground_object = Ground.find(reservation_object[:ground_id])
					ground_name = ground_object.ground_name
					activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
					reservation_info = {:history_for => "ground",:username => username, :ground_obj => ground_object,:obj => reservation_object,:ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reservation_object[:created_at].strftime("%d/%m/%Y")}
					if reservation_object[:cost] != nil
						reservation_info[:cost]= reservation_object[:cost]
					end
					@active_reservations_history.append(reservation_info)
				elsif reservation_object[:status] == INACTIVE_STATUS
					ground_object = Ground.find(reservation_object[:ground_id])
					username = User.find(reservation_object[:user_id]).username
					ground_name = ground_object.ground_name
					ground_owner = ground_object.user_id
					activity_name = SportsMaster.find(reservation_object[:sports_master_id]).name
					reservation_info = {:history_for => "ground",:username => username, :ground_obj => ground_object,:obj => reservation_object,:ground_name => ground_name,:startingtime => Time.at(reservation_object[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reservation_object[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reservation_object[:created_at].strftime("%d/%m/%Y")}
					if reservation_object[:cost] != nil
						reservation_info[:cost]= reservation_object[:cost]
					end
					@inactive_reservations_history.append(reservation_info)
				end
			end
		end
	end

	def cancelreservation
		@res_2_cancel = Reservation.find(params[:id])

    # MANUAL CANCELLATION OF RESERVATIONS
    respond_to do |format|
			if @res_2_cancel.update({:status => INACTIVE_STATUS})
	        format.html { redirect_to root_path, notice: "Reservation was deactivated."}
	    else
	    	format.html { redirect_to root_path, notice: "Couldnt process cancellation request." }
	    end
		end
	end

	def check_in_client
		@res_to_check_in = Reservation.find(params[:id])
		respond_to do |format|
			if @res_to_check_in.update({:status => CHECKED_IN_STATUS})
	      format.html { redirect_to root_path, notice: "User checked in."}
	    else
	    	format.html { redirect_to root_path, notice: "Couldnt check in." }
	    end
		end
	end

	def add_2_favorites
		ground_id = params[:ground_id]
		@cur_ground = Ground.find(ground_id)
		@user_sports_master_object = UserSportsMaster.new({:user_id => current_user.id, :ground_id => ground_id})
		respond_to do |format|
			if @user_sports_master_object.save
        	format.html { redirect_to @cur_ground, notice: "Ground added to favorites."}
	    else
	    	format.html { redirect_to root_path, notice: "Couldnt process request."}
	    end
		end
	end

	def remove_from_favorites
		ground_id = params[:ground_id]
		@cur_ground = Ground.find(ground_id)
		@user_sports_master_object = UserSportsMaster.where({:user_id => current_user.id, :ground_id => ground_id})
		respond_to do |format|
			if @user_sports_master_object.delete_all
	        	format.html { redirect_to @cur_ground, notice: "Ground removed to favorites."}
		    else
		    	format.html { redirect_to root_path, notice: "Couldnt process request."}
		    end
		end
	end

	def favorites_list
		@favorite_grounds = []
		UserSportsMaster.where(user_id: current_user.id).find_each do |user_sports_master_object|
			if user_sports_master_object.ground_id != nil
				ground_obj = Ground.find(user_sports_master_object.ground_id)
				@favorite_grounds.append(ground_obj)
			end
		end
	end

	def groundresults
		@searchword = params[:search_word]
		downcase_searchword = @searchword.downcase
		allgrounds = Ground.all
		@results = []
		@all_activities = []
    all_activity_objects = SportsMaster.all
    all_activity_objects.each do |activity_obj|
      @all_activities.append(activity_obj.name.downcase)
    end
    if @all_activities.include?downcase_searchword
    	result_ground_obj = SportsMaster.where(name:@searchword)[0]
    	render "/grounds/2"
    else
			allgrounds.each do |ground|
				if ground.ground_name.downcase.include?downcase_searchword
					@results.append(ground)
					next
				elsif ground.location.downcase.include?downcase_searchword
					@results.append(ground)
					next
				elsif ground.ground_pincode.to_s == downcase_searchword
					@results.append(ground)
					next
				end
			end
		end
	end
end
