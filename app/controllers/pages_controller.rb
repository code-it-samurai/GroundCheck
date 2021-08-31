require 'time'
class PagesController < ApplicationController
	def home
		# SEND DATA IF SIGNED IN
		if(user_signed_in?)
			@current_user_id = current_user.id
			@current_user_reservations = []
			@current_user_interests = []

			# FINDING AND STORING INTERESTS
			UserSportsMaster.where(user_id: @current_user_id).find_each do |record|
				activity_id = record[:sports_master_id]
				if activity_id
					@current_user_interests.append(SportsMaster.find(activity_id).name)
				end
			end

			# Reservation Status Update
			Reservation.where(user_id: @current_user_id).find_each do |res|
				@active_status = "active"
				@inactive_status = "inactive"
				@hour_left_status = "hour_left"
				@play_on_status = "play_on"
				@checked_in_status = "checked_in"
				@current_date_time = Time.now
				res_starting_time = Time.at(res.starting_time)
				res_finishing_time = Time.at(res.finishing_time)
				starting_time_minus_hour = Time.parse("#{res_starting_time.hour - 1}:#{res_starting_time.min} #{res_starting_time.strftime("%d/%m/%Y")}")
				@comp_time = starting_time_minus_hour
				if res_finishing_time < @current_date_time and (res.status == @active_status or res.status == @hour_left_status or res.status == @play_on_status or res.status == @checked_in_status)
					deactivate_reservation = Reservation.find(res.id)
					deactivate_reservation.update({:status => @inactive_status})
				elsif starting_time_minus_hour < @current_date_time and res.status == @active_status
					hour_left_reservation = Reservation.find(res.id)
					hour_left_reservation.update({:status => @hour_left_status})
					ground_name = Ground.find(res[:ground_id]).ground_name
					activity_name = SportsMaster.find(res[:sports_master_id]).name
					@current_user_reservations.append({:obj => res,:ground_name => ground_name,:startingtime => Time.at(res[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => res[:date].to_formatted_s(:short),:reserved_activity => activity_name})
				elsif res_starting_time < @current_date_time and res_finishing_time > @current_date_time and (res.status == @active_status or res.status == @hour_left_status or res.status == @checked_in_status)
					play_on_reservation = Reservation.find(res.id)										
					play_on_reservation.update({:status => @play_on_status})
					ground_name = Ground.find(res[:ground_id]).ground_name
					activity_name = SportsMaster.find(res[:sports_master_id]).name
					@current_user_reservations.append({:obj => res,:ground_name => ground_name,:startingtime => Time.at(res[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => res[:date].to_formatted_s(:short),:reserved_activity => activity_name})
				elsif res.status == @active_status or res.status == @hour_left_status or res.status == @play_on_status or res.status == @checked_in_status
					ground_name = Ground.find(res[:ground_id]).ground_name
					activity_name = SportsMaster.find(res[:sports_master_id]).name
					@current_user_reservations.append({:obj => res,:ground_name => ground_name,:startingtime => Time.at(res[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => res[:date].to_formatted_s(:short),:reserved_activity => activity_name})					
				end
			end	

			if current_user.ground_owner
				@owned_ground_reservations = []
				@owned_ground = Ground.where(user_id: @current_user_id)[0]
				Reservation.where(ground_id:@owned_ground[:id]).find_each do |rsg|
					if(rsg.status != "inactive")
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
		# HISTORY FOR USR
		if(params[:history_for] == "user")
			@active_reservations_history =[]
			@inactive_reservations_history = []
			@current_user_id = current_user.id
			Reservation.where(user_id: current_user.id).find_each do |reserve_history|
				if reserve_history[:status] == @active_status
					ground_object = Ground.find(reserve_history[:ground_id])
					ground_name = ground_object.ground_name
					activity_name = SportsMaster.find(reserve_history[:sports_master_id]).name
					res_info = {:ground_obj => ground_object,:obj => reserve_history,:ground_name => ground_name,:startingtime => Time.at(reserve_history[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reserve_history[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reserve_history[:created_at].strftime("%d/%m/%Y")}
					if reserve_history[:cost] != nil
						res_info[:cost]= reserve_history[:cost]
					end
					@active_reservations_history.append(res_info)
				else
					ground_object = Ground.find(reserve_history[:ground_id])
					ground_name = ground_object.ground_name
					activity_name = SportsMaster.find(reserve_history[:sports_master_id]).name
					res_info = {:ground_obj => ground_object,:obj => reserve_history,:ground_name => ground_name,:startingtime => Time.at(reserve_history[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reserve_history[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reserve_history[:created_at].strftime("%d/%m/%Y")}
					if reserve_history[:cost] != nil
						res_info[:cost]= reserve_history[:cost]
					end
					@inactive_reservations_history.append(res_info)
				end
			end
		# HISTORY FOR GROUND
		elsif params[:history_for] == "ground"
			@active_reservations_history =[]
			@inactive_reservations_history = []
			@current_ground_id = params[:ground_id]
			Reservation.where(ground_id: @current_ground_id).find_each do |reserve_history|
				if reserve_history[:status] == @active_status
					ground_object = Ground.find(reserve_history[:ground_id])
					ground_name = ground_object.ground_name
					ground_owner = ground_object.user_id
					activity_name = SportsMaster.find(reserve_history[:sports_master_id]).name
					res_info = {:user_obj => ground_owner, :ground_obj => ground_object,:obj => reserve_history,:ground_name => ground_name,:startingtime => Time.at(reserve_history[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reserve_history[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reserve_history[:created_at].strftime("%d/%m/%Y")}
					if reserve_history[:cost] != nil
						res_info[:cost]= reserve_history[:cost]
					end
					@active_reservations_history.append(res_info)
				else
					ground_object = Ground.find(reserve_history[:ground_id])
					ground_name = ground_object.ground_name
					ground_owner = ground_object.user_id
					activity_name = SportsMaster.find(reserve_history[:sports_master_id]).name
					res_info = {:user_obj => ground_owner, :ground_obj => ground_object,:obj => reserve_history,:ground_name => ground_name,:startingtime => Time.at(reserve_history[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => reserve_history[:date].strftime("%d/%m/%Y"),:reserved_activity => activity_name, :created_at => reserve_history[:created_at].strftime("%d/%m/%Y")}
					if reserve_history[:cost] != nil
						@inactive_reservations_history[:cost]= reserve_history[:cost]
					end
					@inactive_reservations_history.append(res_info)
				end
			end
		end
	end

	def cancelreservation
		@res_2_cancel = Reservation.find(params[:id])

    # MANUAL CANCELLATION OF RESERVATIONS
    respond_to do |format|
		if @res_2_cancel.update({:status => @inactive_status})
	        format.html { redirect_to root_path, notice: "Reservation was deactivated."}
	    else
	    	format.html { redirect_to root_path, notice: "Couldnt process cancellation request." }
	    end
		end
	end

	def check_in_client
		# render plain: "#{params[:id]}"
		@res_to_check_in = Reservation.find(params[:id])
		respond_to do |format|
			if @res_to_check_in.update({:status => "checked_in"})
	      format.html { redirect_to root_path, notice: "User checked in."}
	    else
	    	format.html { redirect_to root_path, notice: "Couldnt check in." }
	    end
		end
	end

	def add_2_favorites
		# YOU CANNOT LEAVE AN EMPTY VALUE IN A JUNCTION TABLE
		ground_id = params[:ground_id]
		@cur_ground = Ground.find(ground_id)
		@usm_doc = UserSportsMaster.new({:user_id => current_user.id, :ground_id => ground_id})
		respond_to do |format|
			if @usm_doc.save
	        	format.html { redirect_to @cur_ground, notice: "Ground added to favorites."}
		    else
		    	format.html { redirect_to root_path, notice: "Couldnt process request."}
		    end
		end
	end

	def remove_from_favorites
		ground_id = params[:ground_id]
		@cur_ground = Ground.find(ground_id)
		@usm_doc = UserSportsMaster.where({:user_id => current_user.id, :ground_id => ground_id})
		respond_to do |format|
			if @usm_doc.delete_all
	        	format.html { redirect_to @cur_ground, notice: "Ground removed to favorites."}
		    else
		    	format.html { redirect_to root_path, notice: "Couldnt process request."}
		    end
		end
	end

	def favorites_list
		@favorite_grounds = []
		UserSportsMaster.where(user_id: current_user.id).find_each do |usm|
			if usm.ground_id != nil
				ground_obj = Ground.find(usm.ground_id)
				@favorite_grounds.append(ground_obj)
			end
		end
	end

	def my_grounds
		@mygrounds = []
		Ground.where(user_id: current_user.id).find_each do |groundobj|
			@mygrounds.append(groundobj)
		end
	end

	def ground_search
		render plain: "#{params}"
	end

	def groundresults
		@searchword = params[:search_word]
		downcase_searchword =@searchword.downcase
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
