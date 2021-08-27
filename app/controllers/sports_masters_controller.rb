class SportsMastersController < ApplicationController
  before_action :set_sports_master, only: %i[ show edit update destroy ]

  # GET /sports_masters or /sports_masters.json
  def index
    @sports_masters = SportsMaster.all
  end

  # GET /sports_masters/1 or /sports_masters/1.json
  def show
  end

  # GET /sports_masters/new
  def new
    @sports_master = SportsMaster.new
  end

  # GET /sports_masters/1/edit
  def edit
  end

  # POST /sports_masters or /sports_masters.json
  def create
    # render plain: "#{sports_master_params}"
    @sports_master = SportsMaster.new(sports_master_params)
    respond_to do |format|
      if @sports_master.save
        format.html { redirect_to @sports_master, notice: "Sports master was successfully created." }
        format.json { render :show, status: :created, location: @sports_master }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sports_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sports_masters/1 or /sports_masters/1.json
  def update
    # render plain: "#{sports_master_params}"
    respond_to do |format|
      if @sports_master.update(sports_master_params)
        format.html { redirect_to @sports_master, notice: "Sports master was successfully updated." }
        format.json { render :show, status: :ok, location: @sports_master }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sports_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sports_masters/1 or /sports_masters/1.json
  def destroy
    @sports_master.destroy
    respond_to do |format|
      format.html { redirect_to sports_masters_url, notice: "Sports master was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sports_master
      @sports_master = SportsMaster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # CONFIGURING INDOOR AND OUTDOOR BOOLEANS
    def sports_master_params
      @permit_params = params.require(:sports_master).permit(:name)
      if(params[:sports_master][:type]=="outdoor")
        @permit_params[:outdoor] = true
        @permit_params[:indoor] = false
      elsif (params[:sports_master][:type]=="indoor")
        @permit_params[:indoor] = true
        @permit_params[:outdoor] = false
      end
      return @permit_params
    end
end
