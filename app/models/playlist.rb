class Playlist < ApplicationRecord
    has_many :includes, :foreign_key => "playlist_id", :dependent => :destroy
    has_many :tracks, :through => :includes, :source => :track
end
