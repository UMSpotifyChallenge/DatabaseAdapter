class Track < ApplicationRecord
  belongs_to :album
  has_one :artist, through: :album
  has_many :includes, :foreign_key => "track_id", :dependent => :destroy
  has_many :playlists, :through => :includes, :source => :playlist

  def self.statistics
    attrs = ["acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "key", "liveness", "loudness", "mode", "speechiness", "tempo", "time_signature", "valence"]

    tracks_query = Track.select(attrs).where.not('tempo' => nil)
    tracks = tracks_query.to_a
    tracks.extend(DescriptiveStatistics)

    all_stats = Hash.new
    attrs.each do |attr|
      sym = attr.to_sym
      stats = {
               # :min => tracks.min(&sym),
               # :max => tracks.max(&sym),
               # :mean => tracks.mean(&sym),
               :median => tracks.median(&sym),
               :q1 => tracks.percentile(25, &sym),
               :q2 => tracks.percentile(50, &sym),
               :q3 => tracks.percentile(75, &sym),
               :standard_deviation => tracks.standard_deviation(&sym)
      }
      stats[:min] = tracks_query.minimum(sym)
      stats[:max] = tracks_query.maximum(sym)
      stats[:average] = tracks_query.average(sym).to_f
      all_stats[attr] = stats
      puts all_stats
    end

    f = File.open("public/track_stats.txt", "w")
    f.write(all_stats.to_json)
  end

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
    duration = Track.last.created_at - Track.first.created_at
    counting = Track.last.id - Track.first.id
    puts counting
    speed = counting / duration
    puts speed
    remaining = 2262292.0 - counting
    time_to_finish = remaining / speed
    puts Track.last.created_at + time_to_finish
  end

  # def self.load_spotify
  #   Track.find_in_batches(batch_size: 50) do |tracks|
  #   end
  # end

end