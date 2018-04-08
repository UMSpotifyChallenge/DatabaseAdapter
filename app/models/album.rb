class Album < ApplicationRecord
  belongs_to :artist
  has_many :tracks

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

  def self.speed
    duration = Album.last.created_at - Album.first.created_at
    counting = Album.last.id - Album.first.id
    puts counting
    speed = counting / duration
    puts speed
    remaining = 734684.0 - counting
    time_to_finish = remaining / speed
    puts Album.last.created_at + time_to_finish
  end

end
