class Album < ApplicationRecord
  belongs_to :artist

  def self.load_hadoop_result
    f = File.open("public/mpd_result/album_output.txt", "r")
    f.each_line do |line|
      value = line.split("\t")[1]
      json = JSON.parse(value)
      json["name"] = json["name"][0..254]

      artist_uri = json.delete("artist_uri")
      # artist = Artist.find_by uri: artist_uri
      artist_id = Artist.where(uri: artist_uri).select(:id).take.id
      json["artist_id"] = artist_id

      a = Album.create(json)
      puts a.id
      # id = "\t" + a.id.to_s + "\r"
      # print id
    end
  end
end
