class PublishCheckersController < ApplicationController

  http_basic_authenticate_with name: "tcrosley", password: "tmoney"

  before_action :set_publish_checker, only: [:show, :edit, :update, :destroy]

  # GET /publish_checkers
  # GET /publish_checkers.json
  def index
    @publish_checkers = PublishChecker.all.order(year: :desc, week: :desc)
  end

  # GET /publish_checkers/1
  # GET /publish_checkers/1.json
  def show
  end

  # GET /publish_checkers/new
  def new
    @publish_checker = PublishChecker.new
  end

  # GET /publish_checkers/1/edit
  def edit
  end

  # POST /publish_checkers
  # POST /publish_checkers.json
  def create
    @publish_checker = PublishChecker.new(publish_checker_params)

    respond_to do |format|
      if @publish_checker.save
        format.html { redirect_to @publish_checker, notice: 'Publish checker was successfully created.' }
        format.json { render :show, status: :created, location: @publish_checker }
      else
        format.html { render :new }
        format.json { render json: @publish_checker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publish_checkers/1
  # PATCH/PUT /publish_checkers/1.json
  def update
    respond_to do |format|
      if @publish_checker.update(publish_checker_params)
        format.html { redirect_to @publish_checker, notice: 'Publish checker was successfully updated.' }
        format.json { render :show, status: :ok, location: @publish_checker }
      else
        format.html { render :edit }
        format.json { render json: @publish_checker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publish_checkers/1
  # DELETE /publish_checkers/1.json
  def destroy
    @publish_checker.destroy
    respond_to do |format|
      format.html { redirect_to publish_checkers_url, notice: 'Publish checker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publish_checker
      @publish_checker = PublishChecker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publish_checker_params
      params.require(:publish_checker).permit(:website, :publish_tok, :week, :year)
    end
end
