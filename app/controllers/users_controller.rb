class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  #hello world
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
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
    # render plain: "#{params[:user]}"
    @user = User.new(user_params)
    

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
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
    # render plain: " #{@sports_master.id} #{@user.id} #{UserSportsMaster.where(user_id: @user.id, sports_master_id: @sports_master.id).length}"

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
      @available_activities = []
      user_sports_master = UserSportsMaster.where(user_id: @user.id)
      user_sports_master.each do |usm|
        if usm.sports_master_id != nil
          activity_name = SportsMaster.find(usm.sports_master_id).name
          @available_activities.append(activity_name)
        end
      end
      @all_activities = []
      all_activity_objects = SportsMaster.all
      all_activity_objects.each do |activity_obj|
        @all_activities.append(activity_obj.name)
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :name, :password, :pincode, :address, :email, :phone, :ground_owner)
    end
end
