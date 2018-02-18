class Track < ApplicationRecord
	self.primary_key = "track_uri"
    has_many :includes, :foreign_key => "track_id", :dependent => :destroy
    has_many :playlists, :through => :includes, :source => :playlist
end
