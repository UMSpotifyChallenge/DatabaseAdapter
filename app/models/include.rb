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

        last_p = Playlist.last
        for i in 1..10
            goal = 100000.0*i
            remaining = goal - counting
            time_to_finish = remaining / speed
            puts "- %.1fM:\t%s" % [i*0.1, last_p.created_at.localtime+time_to_finish]
        end

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
