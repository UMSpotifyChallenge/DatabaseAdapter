class Playlist < ApplicationRecord
  has_many :includes, :foreign_key => "playlist_id", :dependent => :destroy
  has_many :tracks, :through => :includes, :source => :track

  serialize :name

  def self.load_mpd_json
    uri_id_map = Hash.new
    Track.select(:id, :uri).each {|t| uri_id_map[t.uri] = t.id }

    Dir["public/data/*.json"].each do |path|
      file = File.read(path)
      json = JSON.parse(file)
      json["playlists"].each do |pl_json|
        pid = pl_json.delete("pid")
        tracks = pl_json.delete("tracks")
        pl_json["modified_at"] = Time.at(pl_json["modified_at"]).to_s

        pl = Playlist.create(pl_json)
        playlist_id = pl.id

        tracks.each do |t|
          track_uri = t["track_uri"][14..-1]
          track_id = uri_id_map[track_uri]
          if track_id == nil
            puts "--- That's what was missing..."
            puts pid
            puts t
          else
            pos = t["pos"]
            Include.create(:playlist_id => playlist_id, :track_id => track_id, :pos => pos)
          end
        end
      end
    end
  end

end

# => Wed, 04 Apr 2018 22:49:28 -0400