class Track < ApplicationRecord
  belongs_to :album
  has_many :includes, :foreign_key => "track_id", :dependent => :destroy
  has_many :playlists, :through => :includes, :source => :playlist
end


# class Album < ApplicationRecord
#   belongs_to :artist
#
#   def self.load_hadoop_result
#     f = File.open("public/mpd_result/album_output.txt", "r")
#     counting = 0
#     f.each_line do |line|
#       value = line.split("\t")[1]
#       json = JSON.parse(value)
#       json["name"] = json["name"][0..254]
#
#       artist_uri = json.delete("artist_uri")
#       artist = Artist.find_by uri: artist_uri
#       json["artist_id"] = artist.id
#
#       a = Album.new(json)
#       id = "\t" + a.artist.id.to_s + "\r"
#       print id
#
#       counting += 1
#       if counting > 100 then
#         break
#       end
#     end
#   end
# end
