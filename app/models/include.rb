class Include < ApplicationRecord
    #attr_accessible :playlist_id, :track_id
    
    belongs_to :playlist, :class_name => "Playlist"
    belongs_to :track, :class_name => "Track"

    validates :playlist_id, :presence => true
    validates :track_id, :presence => true

    def self.speed
        playlist_restart = 64001
        include_restart = 4236165

        puts "---Playlist---"
        last_p = Playlist.last
        duration = last_p.created_at - Playlist.find(playlist_restart).created_at
        counting = last_p.id - playlist_restart
        puts "%d (%.2f%%)" % [last_p.id, (last_p.id / 1000000.0 * 100 )]
        speed = counting / duration
        puts speed

        finished = last_p.id / 100000

        for i in (finished+1)..10
            goal = 100000.0*i
            remaining = goal - last_p.id
            time_to_finish = remaining / speed
            puts "- %.1fM:\t%s" % [i*0.1, last_p.created_at.localtime+time_to_finish]
        end

        puts "---Include---"
        last_include = Include.last
        duration = last_include.created_at - Include.find(include_restart).created_at
        counting = last_include.id - include_restart
        puts "%d (%.2f%%)" % [last_include.id, (last_include.id / 66346428.0 * 100 )]
        speed = counting / duration
        puts speed
        remaining = 66346428.0 - last_include.id
        time_to_finish = remaining / speed
        puts last_include.created_at.localtime + time_to_finish
    end
end
