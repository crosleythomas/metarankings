class ScrapeConfigsController < ApplicationController

  http_basic_authenticate_with name: "tcrosley", password: "tmoney"

  before_action :set_scrape_config, only: [:show, :edit, :update, :destroy]

  # GET /scrape_configs
  # GET /scrape_configs.json
  def index
    @scrape_configs = ScrapeConfig.all.order(year: :desc, week: :desc)
  end

  # GET /scrape_configs/1
  # GET /scrape_configs/1.json
  def show
  end

  # GET /scrape_configs/new
  def new
    @scrape_config = ScrapeConfig.new
  end

  def clone
    old_record = ScrapeConfig.find(params[:id])
    @new_record = ScrapeConfig.create(:website => old_record.website, :url => old_record.url, :rank_xpath => old_record.rank_xpath,
      :rank_regex => old_record.rank_regex, :team_xpath => old_record.team_xpath, :team_regex => old_record.team_regex,
      :description_xpath => old_record.description_xpath, :description_regex => old_record.description_regex, 
      :update_checker_xpath => old_record.update_checker_xpath, :update_checker_regex => old_record.update_checker_regex,
      :week => old_record.week + 1, :year => old_record.year)
    redirect_to edit_scrape_config_path(@new_record.id)
  end

  # GET /scrape_configs/1/edit
  def edit
  end

  # POST /scrape_configs
  # POST /scrape_configs.json
  def create
    @scrape_config = ScrapeConfig.new(scrape_config_params)

    respond_to do |format|
      if @scrape_config.save
        format.html { redirect_to @scrape_config, notice: 'Scrape config was successfully created.' }
        format.json { render :show, status: :created, location: @scrape_config }
      else
        format.html { render :new }
        format.json { render json: @scrape_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scrape_configs/1
  # PATCH/PUT /scrape_configs/1.json
  def update
    respond_to do |format|
      if @scrape_config.update(scrape_config_params)
        format.html { redirect_to @scrape_config, notice: 'Scrape config was successfully updated.' }
        format.json { render :show, status: :ok, location: @scrape_config }
      else
        format.html { render :edit }
        format.json { render json: @scrape_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scrape_configs/1
  # DELETE /scrape_configs/1.json
  def destroy
    @scrape_config.destroy
    respond_to do |format|
      format.html { redirect_to scrape_configs_url, notice: 'Scrape config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scrape_config
      @scrape_config = ScrapeConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scrape_config_params
      params.require(:scrape_config).permit(:website, :url, :rank_xpath, :rank_regex, :team_xpath, :team_regex, :description_xpath, :description_regex, :update_checker_xpath, :update_checker_regex, :week, :year)
    end
end
