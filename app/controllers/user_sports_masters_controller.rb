class UserSportsMastersController < ApplicationController
  before_action :set_user_sports_master, only: %i[ show edit update destroy ]

  # GET /user_sports_masters or /user_sports_masters.json
  def index
    @user_sports_masters = UserSportsMaster.all
  end

  # GET /user_sports_masters/1 or /user_sports_masters/1.json
  def show
  end

  # GET /user_sports_masters/new
  def new
    @user_sports_master = UserSportsMaster.new
  end

  # GET /user_sports_masters/1/edit
  def edit
  end

  # POST /user_sports_masters or /user_sports_masters.json
  def create

    @user_sports_master = UserSportsMaster.new(user_sports_master_params)

    respond_to do |format|
      if @user_sports_master.save
        format.html { redirect_to @user_sports_master, notice: "User sports master was successfully created." }
        format.json { render :show, status: :created, location: @user_sports_master }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_sports_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_sports_masters/1 or /user_sports_masters/1.json
  def update
    respond_to do |format|
      if @user_sports_master.update(user_sports_master_params)
        format.html { redirect_to @user_sports_master, notice: "User sports master was successfully updated." }
        format.json { render :show, status: :ok, location: @user_sports_master }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_sports_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sports_masters/1 or /user_sports_masters/1.json
  def destroy
    @user_sports_master.destroy
    respond_to do |format|
      format.html { redirect_to user_sports_masters_url, notice: "User sports master was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_sports_master
      @user_sports_master = UserSportsMaster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_sports_master_params
      # render plain: "#{params[:user_sports_master]}"
      params.require(:user_sports_master).permit(:user_id, :sports_master_id, :ground_id)
    end
end
