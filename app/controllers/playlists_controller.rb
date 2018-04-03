class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    @playlist = Playlist.find(params[:id])
    @tracks = @playlist.tracks
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  # POST /playlists.json
  def create
    raw_json = params[:playlist][:raw_json]
    if raw_json != nil
      json = JSON.parse(raw_json)
      json.delete("pid")
      tracks = json.delete("tracks")
      @playlist = Playlist.new(json)
      success = @playlist.save
      for j in tracks
        pos = j.delete("pos")
        track_uri = j["track_uri"].delete("spotify:track:")
        j["uri"] = track_uri
        t = Track.new(j)
        # # t = Track.find_by(track_uri: track_uri)
        # if t == nil
        #   # j[:id] = j.delete("track_uri")
        #   t = Track.new(j)
        #   if t.save == false
        #     success = false
        #   end
        # else
        #   puts("already stored")
        # end

        if Include.create(:playlist_id => @playlist.id, :track_id => t.id, :pos => pos) == false
          success = false
        end
      end

      respond_to do |format|
        if success
          format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
          format.json { render :show, status: :created, location: @playlist }
        else
          format.html { render :new }
          format.json { render json: @playlist.errors, status: :unprocessable_entity }
        end
      end

    else
      @playlist = Playlist.new(playlist_params)

      respond_to do |format|
        if @playlist.save
          format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
          format.json { render :show, status: :created, location: @playlist }
        else
          format.html { render :new }
          format.json { render json: @playlist.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :collaborative, :modified_at, :num_tracks, :num_albums, :num_followers, :num_edits, :duration_ms, :num_artists, :description)
    end
end
