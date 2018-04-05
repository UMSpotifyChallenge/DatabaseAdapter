class Include < ApplicationRecord
    #attr_accessible :playlist_id, :track_id
    
    belongs_to :playlist, :class_name => "Playlist"
    belongs_to :track, :class_name => "Track"

    validates :playlist_id, :presence => true
    validates :track_id, :presence => true

    def self.speed
        puts "---Playlist---"
        duration = Playlist.last.created_at - Playlist.first.created_at
        counting = Playlist.last.id - Playlist.first.id
        puts counting
        speed = counting / duration
        puts speed
        remaining = 1000000.0 - counting
        time_to_finish = remaining / speed
        puts Playlist.last.created_at.localtime + time_to_finish

        puts "---Include---"
        duration = Include.last.created_at - Include.first.created_at
        counting = Include.last.id - Include.first.id
        puts counting
        speed = counting / duration
        puts speed
        remaining = 66346428.0 - counting
        time_to_finish = remaining / speed
        puts Include.last.created_at.localtime + time_to_finish
    end
end
