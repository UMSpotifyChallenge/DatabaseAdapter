class Playlist < ApplicationRecord
    has_many :includes, :foreign_key => "playlist_id", :dependent => :destroy
    has_many :tracks, :through => :includes, :source => :track

    def self.read_file(index)
      name = "public/mpd.slice.%d-%d.json" % [index, (index+1)*1000-1]
      file = File.read(name)
      data = JSON.parse(file)
      return data
    end

end
