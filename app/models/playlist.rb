class Playlist < ApplicationRecord
  has_many :includes, :foreign_key => "playlist_id", :dependent => :destroy
  has_many :tracks, :through => :includes, :source => :track

  serialize :name
  serialize :description

  def track_list
    # includes = Include.where('id >= ? AND playlist_id = ?', start, id).limit(num_tracks)
    # return includes # .map {|i| i.track}
    return Track.joins(:includes).where('includes.id >= ? AND includes.playlist_id = ?', start, id).limit(num_tracks) #.order('includes.pos')
  end

  def self.compute_start
    iid = 1
    Playlist.find_each do |p|
      start_include = p.includes.where('id >= ? AND playlist_id = ? AND pos = ?', iid, p.id, 0).first
      if start_include == nil
        puts "Order problem"
        puts p.id
        start_include = p.includes.where('playlist_id = ? AND pos = ?', p.id, 0).first
      end
      if start_include == nil
        puts "No pos=0"
        puts p.id
        start_include = p.includes.first
      end
      iid = start_include.id
      # puts "playlist%d \t %d" % [p.id, iid]
      p.update_attribute(:start, iid)
    end
  end

  def self.speed
    updated = Playlist.where.not('start' => nil)
    last_updated = updated.last
    last_updated_id = last_updated.id
    first_updated =  Playlist.find(30707)

    puts "%d (%.2f%%)" % [last_updated_id, (last_updated_id / 1000000.0 * 100 )]

    duration = last_updated.updated_at - first_updated.updated_at
    counting = last_updated_id - first_updated.id
    speed = counting / duration
    puts speed
    remaining = 1000000.0 - last_updated_id
    time_to_finish = remaining / speed
    puts last_updated.updated_at.localtime + time_to_finish
  end

  def self.load_mpd_json
    # puts ("HashStart:" + Time.current.to_s)
    # uri_id_map = Hash.new
    # Track.select(:id, :uri).each {|t| uri_id_map[t.uri] = t.id }
    # # File.open("public/uri_id_map.json","w") do |f|
    # #   f.write(uri_id_map.to_json)
    # # end
    # puts ("HashEnd:" + Time.current.to_s)

    start = Time.current
    path = "public/uri_id_map.json"
    file = File.read(path)
    uri_id_map = JSON.parse(file)
    finish = Time.current
    elapsed = finish - start
    puts ("JSON loading: " + elapsed.to_s)

    Dir["public/data/*.json"].each do |path|
      puts path

      file = File.read(path)
      json = JSON.parse(file)
      json["playlists"].each do |pl_json|
        pid = pl_json.delete("pid")
        puts pid
        tracks = pl_json.delete("tracks")
        pl_json["modified_at"] = Time.at(pl_json["modified_at"]).to_s

        pl = Playlist.create(pl_json)
        playlist_id = pl.id

        Include.bulk_insert(:playlist_id, :track_id, :pos, :created_at, :updated_at) do |worker|
          tracks.each do |t|
            track_uri = t["track_uri"][14..-1]
            track_id = uri_id_map[track_uri]
            if track_id == nil
              puts "--- That's what was missing..."
              puts pid
              puts t
            else
              pos = t["pos"]
              worker.add playlist_id: playlist_id, track_id: track_id, pos: pos
              # Include.create(:playlist_id => playlist_id, :track_id => track_id, :pos => pos)
            end
          end

        end
      end

      FileUtils.mv(path, path+"_done")
    end
  end

  def self.check_loaded
    loaded_first_list = Playlist.where('id % 1000 = 1')

    Dir["public/data/*.json"].each do |path|
      pls = get_pls_of_path(path)
      first_pl = pls[0]

      if loaded_first_list.exists?(:name => first_pl["name"], :num_tracks =>  first_pl["num_tracks"])
        puts "Loaded: " + path
        FileUtils.mv(path, path+"_done")
      end
    end
  end

  def self.move_done_files
    Dir["public/data/*.json"].each do |path|
      puts path

      FileUtils.mv(path, path+"_done")
    end
    puts "DONE"
  end

  def self.get_pls_of_path(path)
    file = File.read(path)
    json = JSON.parse(file)
    return json["playlists"]
  end

  def self.fix_remaining(path, from)
    uri_id_map = Hash.new
    Track.select(:id, :uri).each {|t| uri_id_map[t.uri] = t.id }

    # path = "public/data/mpd.slice.482000-482999.json"
    file = File.read(path)
    json = JSON.parse(file)
    pls = json["playlists"]
    for i in from..999
      pl_json = pls[i]
      load_pl_json(pl_json, uri_id_map)
    end
  end

  # 31278

  def self.load_pl_json(pl_json, uri_id_map)
    pid = pl_json.delete("pid")
    puts pid
    tracks = pl_json.delete("tracks")
    pl_json["modified_at"] = Time.at(pl_json["modified_at"]).to_s

    pl = Playlist.create(pl_json)
    playlist_id = pl.id

    tracks.each do |t|
      track_uri = t["track_uri"][14..-1]
      track_id = uri_id_map[track_uri]
      if track_id == nil
        puts "--- That's what was missing..."
        puts pid
        puts t
      else
        pos = t["pos"]
        Include.create(:playlist_id => playlist_id, :track_id => track_id, :pos => pos)
      end
    end
  end

  def self.fix_704
    # uri_id_map = Hash.new
    # Track.select(:id, :uri).each {|t| uri_id_map[t.uri] = t.id }

    path = "public/data/mpd.slice.482000-482999.json"
    file = File.read(path)
    json = JSON.parse(file)
    pls = json["playlists"]
    pl_json = pls[704]
    playlist_id = 30705

    pid = pl_json.delete("pid")
    tracks = pl_json.delete("tracks")

    tracks.each do |t|
      track_uri = t["track_uri"][14..-1]
      track_id = Track.find_by(uri: track_uri).id #uri_id_map[track_uri]
      if track_id == nil
        puts "--- That's what was missing..."
        puts pid
        puts t
      else
        pos = t["pos"]
        Include.create(:playlist_id => playlist_id, :track_id => track_id, :pos => pos)
      end
    end

  end

end

# => Wed, 04 Apr 2018 22:49:28 -0400
