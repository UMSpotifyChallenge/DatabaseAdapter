class Include < ApplicationRecord
    #attr_accessible :playlist_id, :track_id
    
    belongs_to :playlist, :class_name => "Playlist"
    belongs_to :track, :class_name => "Track"

    validates :playlist_id, :presence => true
    validates :track_id, :presence => true

    def self.speed
        playlist_restart = 31001
        include_restart = 2048546

        puts "---Playlist---"
        last_p = Playlist.last
        duration = last_p.created_at - Playlist.find(playlist_restart).created_at
        counting = last_p.id - playlist_restart
        puts counting
        speed = counting / duration
        puts speed

        for i in 1..10
            goal = 100000.0*i
            remaining = goal - last_p.id
            time_to_finish = remaining / speed
            puts "- %.1fM:\t%s" % [i*0.1, last_p.created_at.localtime+time_to_finish]
        end

        puts "---Include---"
        duration = Include.last.created_at - Include.find(include_restart).created_at
        counting = Include.last.id - include_restart
        puts counting
        speed = counting / duration
        puts speed
        remaining = 66346428.0 - counting
        time_to_finish = remaining / speed
        puts Include.last.created_at.localtime + time_to_finish
    end
end
