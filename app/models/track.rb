class Track < ApplicationRecord
  belongs_to :album
  has_many :includes, :foreign_key => "track_id", :dependent => :destroy
  has_many :playlists, :through => :includes, :source => :playlist

  def self.load_hadoop_result
    uri_id_map = Hash.new
    Album.select(:id, :uri).each {|a| uri_id_map[a.uri] = a.id }

    f = File.open("public/mpd_result/track_output.txt", "r")
    f.each_line do |line|
      value = line.split("\t")[1]
      json = JSON.parse(value)
      json["name"] = json["name"][0..254]

      album_uri = json.delete("album_uri")
      album_id = uri_id_map[album_uri]
      json["album_id"] = album_id

      t = Track.create(json)
      puts t.id
    end
  end

  # def self.load_spotify
  #   Track.find_in_batches(batch_size: 50) do |tracks|
  #   end
  # end

end