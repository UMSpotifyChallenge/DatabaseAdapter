class Track < ApplicationRecord
  belongs_to :album
  has_many :includes, :foreign_key => "track_id", :dependent => :destroy
  has_many :playlists, :through => :includes, :source => :playlist

  def self.load_hadoop_result

    puts ("HashStart:" + Time.current.to_s)
    uri_id_map = Hash.new
    Album.select(:id, :uri).each {|a| uri_id_map[a.uri] = a.id }
    puts ("HashEnd:" + Time.current.to_s)

    f = File.open("public/mpd_result/track_output.txt", "r")
    f.each_line do |line|
      value = line.split("\t")[1]
      json = JSON.parse(value)
      json["name"] = json["name"][0..254]

      album_uri = json.delete("album_uri")
      album_id = uri_id_map[album_uri]
      json["album_id"] = album_id

      t = Track.create(json)

      if t.id % 1000 == 0 then
        self.speed
      end
      
    end
  end

  def self.speed
    updated = Track.where.not('acousticness' => nil)
    last_updated = updated.last
    last_updated_id = last_updated.id
    first_updated =  Track.find(1239072)

    puts "%d (%.2f%%)" % [last_updated_id, (last_updated_id / 2262292.0 * 100 )]

    duration = last_updated.updated_at - first_updated.updated_at
    counting = last_updated_id - first_updated.id
    speed = counting / duration
    puts speed
    remaining = 2262292.0 - last_updated_id
    time_to_finish = remaining / speed
    puts last_updated.updated_at + time_to_finish
  end

  def self.request_spotify_api
    keys_to_delete = %w(analysis_url track_href external_urls href id type uri)

    fix_holes
    start_from = Track.where('acousticness' => nil).first.id

    iteration = 0
    Track.find_in_batches(batch_size: 100, start: start_from) do |tracks|
      if iteration%49 == 0
        puts iteration
        case ((iteration/49) % 3)
          when 0
            puts "Auth ZERO"
            RSpotify.authenticate("6b76fbdce4f84d07959cb56066e43495","596c6c2badd047c187c9b15a7006f007")
          when 1
            puts "Auth ONE"
            RSpotify.authenticate("eac23cf20394464a842dbb05d3322bf3","c9a568c6d6e94944b204c91a98473cfd")
          when 2
            puts "Auth TWO"
            RSpotify.authenticate("30a897510f9243e2a10a40cb77456210","d6a8b4b244e8408480ce29c260c26bf7")
        end
      end
      iteration += 1

      uri_list = tracks.map { |t| t.uri }
      af_list = RSpotify::AudioFeatures.find(uri_list)
      af_list.each do |af|
        if af == nil
          puts "missing track_uri"
          # just, let's run fix_holes before.
          # Track.find(22131).update_attribute(:acousticness,-1)
        else
          json = JSON.parse(af.to_json)
          uri = json["id"]
          keys_to_delete.each { |k| json.delete(k) }

          track = tracks.find {|t| t.uri == uri }
          track.update_attributes(json)
        end
      end
    end
  end

  def self.fix_holes
    while true
      hole = Track.where('acousticness' => nil).first.id
      puts hole
      next_item = Track.find(hole+1)
      if next_item.acousticness == nil
        return
      end
      Track.find(hole).update_attribute(:acousticness,-1)
    end
  end

end