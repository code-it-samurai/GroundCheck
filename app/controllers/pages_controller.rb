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

			#DEACTIVATING RESERVATIONS WHICH ARE OUTDATED
			@available_res_timings = []			
			Reservation.where(user_id: @current_user_id).find_each do |res|
				@available_res_timings.append("#{Time.at(res.starting_time)} #{Time.at(res.finishing_time)} ct #{Time.now}")
				res_finishing_time = Time.at(res.finishing_time)
				current_time = Time.now
				if(res_finishing_time > current_time and res.active)
					ground_name = Ground.find(res[:ground_id]).ground_name
					activity_name = SportsMaster.find(res[:sports_master_id]).name
					@current_user_reservations.append({:obj => res,:ground_name => ground_name,:startingtime => Time.at(res[:starting_time]).to_time.strftime("%I:%M %p"),:reservation_date => res[:date].to_formatted_s(:short),:reserved_activity => activity_name})
				else
					@current_res = Reservation.find(res.id)
					@current_res.update({:active => false})
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
				if reserve_history[:active]
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
				if reserve_history[:active]
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
		@res_2_cancel.update({:active => false})

    # MANUAL CANCELLATION OF RESERVATIONS
	    respond_to do |format|
			if @res_2_cancel.update({:active => false})
		        format.html { redirect_to root_path, notice: "Reservation was deactivated."}
		    else
		    	format.html { redirect_to root_path, notice: "Couldnt process cancellation request." }
		    end
		end
	end

	def add_2_favorites
		# YOU CANNOT LEAVE AN EMPTY VALUE IN A JUNCTION TABLE
		# render plain: "#{params}"
		ground_id = params[:ground_id]
		@cur_ground = Ground.find(ground_id)
		@usm_doc = UserSportsMaster.new({:user_id => current_user.id, :ground_id => ground_id})
		# render plain: "#{{:user_id => current_user.id, :ground_id => ground_id}.inspect}"
		respond_to do |format|
			if @usm_doc.save
	        	format.html { redirect_to @cur_ground, notice: "Ground added to favorites."}
		    else
		    	format.html { redirect_to root_path, notice: "Couldnt process request."}
		    end
		end
	end

	def remove_from_favorites
		# render plain: "#{params}"
		ground_id = params[:ground_id]
		@cur_ground = Ground.find(ground_id)
		@usm_doc = UserSportsMaster.where({:user_id => current_user.id, :ground_id => ground_id})
		# render plain: "#{{:user_id => current_user.id, :ground_id => ground_id}.inspect}"
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
		# render plain: "#{params}"
		@searchword = params[:search_word]
		allgrounds = Ground.all
		@results = []
		allgrounds.each do |ground|
			if ground.ground_name.downcase.include?@searchword
				@results.append(ground)
				next
			elsif ground.location.downcase.include?@searchword
				@results.append(ground)
				next
			elsif ground.ground_pincode.to_s == @searchword
				@results.append(ground)
				next
			end
		end
		# @all_grounds = Ground.find_each
	end
end
