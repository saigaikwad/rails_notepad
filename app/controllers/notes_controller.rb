class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  before_action :authenticate_user!

  before_action :correct_user,only: [:edit,:update,:destroy]

  # GET /notes or /notes.json
  def index
    @notes = Note.all

    @q = Note.ransack(params[:q])
    @notes = @q.result(distinct: true)
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

#for searching the notes
  def search
    @note = Note.where("title LIKE ?", "%" + params[:q] + "%")
    
  end

  # GET /notes/new
  def new
    #@note = Note.new
    @note = current_user.notes.build

  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    #@note = Note.new(note_params)
    #
    @note = current_user.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @note = current_user.notes.find_by(id: params[:id])
    redirect_to notes_path, notice: "Not Authorized" if @notes.nil?
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :description, :user_id)
    end
end
