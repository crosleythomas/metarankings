class RanksController < ApplicationController

  http_basic_authenticate_with name: "tcrosley", password: "tmoney", :except => [:index, :index2, :indexWeek, :about, :statistics]

  before_action :set_rank, only: [:show, :edit, :update, :destroy]

  def index2
    @ranks = Rank.all
    render 'ranks/display.html.erb'
  end

  # GET /ranks
  # GET /ranks.json
  def index
    @websites = ['CBS', 'FOX', 'ESPN', 'USA', 'BR', 'Rant' 'BI', 'MLB']
    
    @CBS_query = Rank.where(:website => 'CBS').order(year: :desc, week: :desc).first(30)
    @CBS_ranks = {}
    if !@CBS_query.nil?
      @CBS_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @CBS_ranks[q.rank] = team_array
      end
    end

    @ESPN_query = Rank.where(:website => 'ESPN').order(year: :desc, week: :desc).first(30)
    @ESPN_ranks = {}
    if !@ESPN_query.nil?
      @ESPN_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @ESPN_ranks[q.rank] = team_array
      end
    end

    @FOX_query = Rank.where(:website => 'FOX').order(year: :desc, week: :desc).first(30)
    @FOX_ranks = {}
    if !@FOX_query.nil?
      @FOX_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @FOX_ranks[q.rank] = team_array
      end
    end

    @USA_query = Rank.where(:website => 'USA').order(year: :desc, week: :desc).first(30)
    @USA_ranks = {}
    if !@USA_query.nil?
      @USA_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @USA_ranks[q.rank] = team_array
      end
    end

    @BR_query = Rank.where(:website => 'BR').order(year: :desc, week: :desc).first(30)
    @BR_ranks = {}
    @BR_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @BR_ranks[q.rank] = team_array
    end     

    @Rant_query = Rank.where(:website => 'Rant').order(year: :desc, week: :desc).first(30)
    @Rant_ranks = {}
    @Rant_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @Rant_ranks[q.rank] = team_array
    end

      @BI_query = Rank.where(:website => 'BI').order(year: :desc, week: :desc).first(30)
    @BI_ranks = {}
    @BI_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @BI_ranks[q.rank] = team_array
    end

      @MLB_query = Rank.where(:website => 'MLB').order(year: :desc, week: :desc).first(30)
    @MLB_ranks = {}
    @MLB_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @MLB_ranks[q.rank] = team_array
    end

    @image_results = Image.all
    @images = {}

    @image_results.each do |image|
      @images[image.team_name] = image.url
    end

  end

  def indexWeek
    @websites = ['CBS', 'FOX', 'ESPN', 'USA', 'BR', 'Rant' 'BI', 'MLB']
    
    @CBS_query = Rank.where(:week => params[:week], :website => 'CBS').order(year: :desc, week: :desc).first(30)
    @CBS_ranks = {}
    if !@CBS_query.nil?
      @CBS_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @CBS_ranks[q.rank] = team_array
      end
    end

    @ESPN_query = Rank.where(:week => params[:week], :website => 'ESPN').order(year: :desc, week: :desc).first(30)
    @ESPN_ranks = {}
    if !@ESPN_query.nil?
      @ESPN_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @ESPN_ranks[q.rank] = team_array
      end
    end

    @FOX_query = Rank.where(:week => params[:week], :website => 'FOX').order(year: :desc, week: :desc).first(30)
    @FOX_ranks = {}
    if !@FOX_query.nil?
      @FOX_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @FOX_ranks[q.rank] = team_array
      end
    end

    @USA_query = Rank.where(:week => params[:week], :website => 'USA').order(year: :desc, week: :desc).first(30)
    @USA_ranks = {}
    if !@USA_query.nil?
      @USA_query.each do |q|
        team_array = [q.team, q.description, q.article_link]
        @USA_ranks[q.rank] = team_array
      end
    end

    @BR_query = Rank.where(:week => params[:week], :website => 'BR').order(year: :desc, week: :desc).first(30)
    @BR_ranks = {}
    @BR_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @BR_ranks[q.rank] = team_array
    end     

    @Rant_query = Rank.where(:week => params[:week], :website => 'Rant').order(year: :desc, week: :desc).first(30)
    @Rant_ranks = {}
    @Rant_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @Rant_ranks[q.rank] = team_array
    end

      @BI_query = Rank.where(:week => params[:week], :website => 'BI').order(year: :desc, week: :desc).first(30)
    @BI_ranks = {}
    @BI_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @BI_ranks[q.rank] = team_array
    end

      @MLB_query = Rank.where(:week => params[:week], :website => 'MLB').order(year: :desc, week: :desc).first(30)
    @MLB_ranks = {}
    @MLB_query.each do |q|
      team_array = [q.team, q.description, q.article_link]
      @MLB_ranks[q.rank] = team_array
    end

    @image_results = Image.all
    @images = {}

    @image_results.each do |image|
      @images[image.team_name] = image.url
    end
    render 'ranks/index'
  end

  def about
    render '/ranks/about'
  end

  # GET /ranks/1
  # GET /ranks/1.json
  def show
  end

  # GET /ranks/new
  def new
    @rank = Rank.new
  end

  # GET /ranks/1/edit
  def edit
  end

  # POST /ranks
  # POST /ranks.json
  def create
    @rank = Rank.new(rank_params)

    respond_to do |format|
      if @rank.save
        format.html { redirect_to @rank, notice: 'Rank was successfully created.' }
        format.json { render :show, status: :created, location: @rank }
      else
        format.html { render :new }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ranks/1
  # PATCH/PUT /ranks/1.json
  def update
    respond_to do |format|
      if @rank.update(rank_params)
        format.html { redirect_to @rank, notice: 'Rank was successfully updated.' }
        format.json { render :show, status: :ok, location: @rank }
      else
        format.html { render :edit }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ranks/1
  # DELETE /ranks/1.json
  def destroy
    @rank.destroy
    respond_to do |format|
      format.html { redirect_to ranks_url, notice: 'Rank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rank
      @rank = Rank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rank_params
      params.require(:rank).permit(:website, :team, :rank, :week, :year, :description, :article_link, :published)
    end
end
