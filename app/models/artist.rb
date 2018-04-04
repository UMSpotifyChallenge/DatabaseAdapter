class Artist < ApplicationRecord
  def self.load_hadoop_result
    f = File.open("public/mpd_result/artist_output.txt", "r")
    f.each_line do |line|
      value = line.split("\t")[1]
      json = JSON.parse(value)
      json["name"] = json["name"][0..255]
      Artist.create(json)
    end
  end
end
