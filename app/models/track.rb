class Track < ApplicationRecord
  belongs_to :album
  has_many :includes, :foreign_key => "track_id", :dependent => :destroy
  has_many :playlists, :through => :includes, :source => :playlist

  def self.load_hadoop_result
    f = File.open("public/mpd_result/track_output.txt", "r")
    f.each_line do |line|
      value = line.split("\t")[1]
      json = JSON.parse(value)
      json["name"] = json["name"][0..254]

      album_uri = json.delete("album_uri")
      album_id = Album.where(uri: album_uri).select(:id).take.id
      json["album_id"] = album_id

      t = Track.create(json)
      puts t.id
    end
  end

  def self.request_spotify_api
    keys_to_delete = %w(analysis_url track_href external_urls href id type uri)

    iteration = 0
    Track.find_in_batches(batch_size: 50) do |tracks|
      case (iteration % 3)
        when 0
          RSpotify.authenticate("6b76fbdce4f84d07959cb56066e43495","596c6c2badd047c187c9b15a7006f007")
        when 1
          RSpotify.authenticate("eac23cf20394464a842dbb05d3322bf3","c9a568c6d6e94944b204c91a98473cfd")
        when 2
          RSpotify.authenticate("30a897510f9243e2a10a40cb77456210","d6a8b4b244e8408480ce29c260c26bf7")
      end
      iteration += 1

      uri_list = tracks.map { |t| t.uri }
      af_list = RSpotify::AudioFeatures.find(uri_list)
      af_list.each do |af|
        json = JSON.parse(af.to_json)
        uri = json["id"]
        keys_to_delete.each { |k| json.delete(k) }

        track = tracks.find {|t| t.uri == uri }
        track.update_attributes(json)
      end
    end
  end

end