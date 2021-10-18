class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  #hello world
  # GET /users or /users.json
  def index
    @users = User.all
  end

  def get_all_available_activities
    all_activities = []
    all_activity_objects = SportsMaster.all
    all_activity_objects.each do |activity_obj|
      all_activities.append(activity_obj.name)
    end
    return all_activities
  end

  # GET /users/1 or /users/1.json
  def show
    @sus_user = false
    if current_user.id != @user.id
      @sus_user = true
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @sus_user = false
    if(user_signed_in?)
      if current_user.id != @user.id
        @sus_user = true
      end
    end
    @available_activities = []
    user_sports_master = UserSportsMaster.where(user_id: @user.id)
    user_sports_master.each do |usm|
      if usm.sports_master_id != nil
        activity_name = SportsMaster.find(usm.sports_master_id).name
        @available_activities.append(activity_name)
      end
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.save

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Your profile was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # render plain: "#{user_params}"
    @user.update(user_params)
    activities = params[:user][:sports_activities]
    # SAVING SELECTED ACTIVITIES
    UserSportsMaster.where(user_id:params[:id]).find_each do |new_usm|
      if new_usm.sports_master_id != nil
        new_usm.delete
      end
    end

    if activities
      activities.each do |activity|
        @sports_master = SportsMaster.where(name:activity)[0]
        @usersportsmaster = UserSportsMaster.new()
        @usersportsmaster.user_id = @user.id
        @usersportsmaster.sports_master_id = @sports_master[:id]
        if UserSportsMaster.where(user_id: @user.id, sports_master_id: @sports_master.id).length == 0
          @usersportsmaster.save        
        end
      end
    end

    respond_to do |format|
      if @user.update(user_params)
          
        format.html { redirect_to root_path, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])

      # Getting names of all the activities user is interested in in an array
      @available_activities = []
      user_sports_master = UserSportsMaster.where(user_id: @user.id)
      user_sports_master.each do |usm|
        if usm.sports_master_id != nil
          activity_name = SportsMaster.find(usm.sports_master_id).name
          @available_activities.append(activity_name)
        end
      end
      # Getting the names of all the activities in sports master inside an array
      @all_activities = get_all_available_activities()
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :name, :password, :pincode, :address, :email, :phone, :ground_owner)
    end
end
