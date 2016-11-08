class KeyvalsController < ApplicationController

  http_basic_authenticate_with name: "tcrosley", password: "tmoney"

  before_action :set_keyval, only: [:show, :edit, :update, :destroy]

  # GET /keyvals
  # GET /keyvals.json
  def index
    @keyvals = Keyval.all
  end

  # GET /keyvals/1
  # GET /keyvals/1.json
  def show
  end

  # GET /keyvals/new
  def new
    @keyval = Keyval.new
  end

  # GET /keyvals/1/edit
  def edit
  end

  # POST /keyvals
  # POST /keyvals.json
  def create
    @keyval = Keyval.new(keyval_params)

    respond_to do |format|
      if @keyval.save
        format.html { redirect_to @keyval, notice: 'Keyval was successfully created.' }
        format.json { render :show, status: :created, location: @keyval }
      else
        format.html { render :new }
        format.json { render json: @keyval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /keyvals/1
  # PATCH/PUT /keyvals/1.json
  def update
    respond_to do |format|
      if @keyval.update(keyval_params)
        format.html { redirect_to @keyval, notice: 'Keyval was successfully updated.' }
        format.json { render :show, status: :ok, location: @keyval }
      else
        format.html { render :edit }
        format.json { render json: @keyval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keyvals/1
  # DELETE /keyvals/1.json
  def destroy
    @keyval.destroy
    respond_to do |format|
      format.html { redirect_to keyvals_url, notice: 'Keyval was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyval
      @keyval = Keyval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def keyval_params
      params.require(:keyval).permit(:key, :value)
    end
end
