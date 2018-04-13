class Track < ApplicationRecord
  belongs_to :album
  has_one :artist, through: :album
  has_many :includes, :foreign_key => "track_id", :dependent => :destroy
  has_many :playlists, :through => :includes, :source => :playlist

  @attrs = ["id", "album_id", "acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "key", "liveness", "loudness", "mode", "speechiness", "tempo", "time_signature", "valence"]
  
  def self.in_popular_playlists(counts)
    attrs = @attrs

    tracks_list = Playlist.limit(counts).map {|p| p.track_list.select(attrs) }
    tracks = tracks_list.flatten.to_set.to_a

    return tracks
  end

  def self.to_csv(ary)
    result = ""
    ary.each {|i| result += ",%s" % i.to_s }
    result += "\n"
    return result[1..-1]
  end

  def self.print_tracks_in_csv(counts)
    f = File.open("public/track_features_%d.csv" % counts, "w")
    tracks = in_popular_playlists counts

    attrs = @attrs
    csv = to_csv attrs
    f.write csv

    tracks.each do |t|
      as_ary = attrs.map {|a| t[a] }
      csv = to_csv as_ary
      f.write csv
    end

    return nil
  end

  def self.print_hyperedges(counts)
    tracks = in_popular_playlists counts

    attrs = tracks[0].attribute_names
    f = File.open("public/tracks_%d(%d).csv" % [counts, tracks.count], "w")
    f.write(to_csv attrs)
    tracks.each do |t|
      values = attrs.map {|a| t[a]}
      f.write(to_csv values)
    end
    f.close

    # path = "hyperedges_%d" % tracks.count
    #
    # print_hyperedges_of_feature(path, tracks, "acousticness", [0, 0.01, 0.3, 0.622, 1.1], false)
    # print_hyperedges_of_feature(path, tracks, "danceability", [0, 0.403, 0.575, 0.747, 1.1], false)
    # print_hyperedges_of_feature(path, tracks, "energy", [0, 0.368,	0.613,	0.859, 1.1], false)
    # print_hyperedges_of_feature(path, tracks, "instrumentalness", [0, 1e-6,	0.002, 0.686, 1.1], false)
    # print_hyperedges_of_feature(path, tracks, "liveness", [0, 0.028, 0.195, 0.363,1.1], false)
    # print_hyperedges_of_feature(path, tracks, "loudness", [-60, -13.44, -8.36, -3.28, 4], false)
    # print_hyperedges_of_feature(path, tracks, "speechiness", [0, 0.04, 0.093,	0.210,1.1], false)
    # print_hyperedges_of_feature(path, tracks, "tempo", [0, 91.104,	120.717, 150.330, 250], false)
    # print_hyperedges_of_feature(path, tracks, "valence", [0, 0.219, 0.475, 0.731, 1.1], false)
    # print_hyperedges_of_feature(path, tracks, "key", (0...12).to_a, true)
    # print_hyperedges_of_feature(path, tracks, "mode", [0,1], true)
    # print_hyperedges_of_feature(path, tracks, "time_signature", (0..5).to_a, true)
  end

  def self.print_hyperedges_of_feature(path_prefix, tracks, attr, splits, discrete)
    clusters = discrete ? splits.count : splits.count-1
    f = File.open("public/%s_%s(%d).txt" % [path_prefix, attr, clusters], "w")

    counts = 0
    if discrete
      splits.each do |s|
        selected = tracks.select {|t| t[attr] == s}
        selected.each do |t|
          counts += 1
          f.write("%d\t%s_%d\n" % [t.id, attr, s])
        end
      end
    else
      ranges = (0...(splits.count-1)).map {|i| splits[i]...splits[i + 1]}
      ranges.each do |r|
        selected = tracks.select {|t| r.include? t[attr]}
        selected.each do |t|
          counts += 1
          f.write("%d\t%s_%s\n" % [t.id, attr, r.to_s])
        end
      end
    end
    puts attr + ": " + counts.to_s
    return counts
  end

  def self.print_track_feature_statistics(counts)
    f = File.open("public/track_statistics_%d.csv" % counts, "w")
    tracks = in_popular_playlists counts
    tracks.extend(DescriptiveStatistics)

    attrs = ["acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "key", "liveness", "loudness", "mode", "speechiness", "tempo", "time_signature", "valence"]
    # tracks_query = Track.select(attrs).where.not('tempo' => nil)
    # tracks = tracks_query.to_a

    attrs.each do |attr|
      sym = attr.to_sym
      f.write(attr + ",")
      values = DescriptiveStatistics::Support::convert(tracks, &sym)
      f.write(values.mean.to_s + ",")
      f.write(values.standard_deviation.to_s + ",")
      f.write(values.min.to_s + ",")
      f.write(values.max.to_s + ",")
      f.write(values.percentile(10).to_s + ",")
      f.write(values.percentile(20).to_s + ",")
      f.write(values.percentile(30).to_s + ",")
      f.write(values.percentile(40).to_s + ",")
      f.write(values.percentile(50).to_s + ",")
      f.write(values.percentile(60).to_s + ",")
      f.write(values.percentile(70).to_s + ",")
      f.write(values.percentile(80).to_s + ",")
      f.write(values.percentile(90).to_s + "\n")
    end

  end

  def self.statistics
    attrs = ["acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "key", "liveness", "loudness", "mode", "speechiness", "tempo", "time_signature", "valence"]

    tracks_query = Track.select(attrs).where.not('tempo' => nil) #.limit(counts)
    tracks = tracks_query.to_a
    # tracks_list = Playlist.order(num_followers: :desc).limit(counts).map {|p| p.track_list }
    # tracks = tracks_list.flatten.to_set.to_a
    tracks.extend(DescriptiveStatistics)

    puts tracks.count

    all_stats = Hash.new
    attrs.each do |attr|
      sym = attr.to_sym
      values = DescriptiveStatistics::Support::convert(tracks, &sym)
      stats = {
               :min => values.min,
               :max => values.max,
               :average => values.mean,
               :median => values.median,
               :p20 => values.percentile(20),
               :p40 => values.percentile(40),
               :p60 => values.percentile(60),
               :p80 => values.percentile(80),
               :standard_deviation => values.standard_deviation
      }
      # stats[:min] = tracks_query.minimum(sym)
      # stats[:max] = tracks_query.maximum(sym)
      # stats[:average] = tracks_query.average(sym).to_f
      all_stats[attr] = stats
    end

    f = File.open("public/track_stats_%d.txt" % counts, "w")
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