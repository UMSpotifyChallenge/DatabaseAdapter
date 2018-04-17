# Spotify RecSys Challenge Data Analysis

* For ACM RecSys Challenge 2018
* Organize Million Playlist Data by Spotify 
* Load and store audio features of tracks using Spotify API
* Prepare data in the format for higher order network and hypergraph
  
# Instruction
* install ruby and rails

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s stable --rails

* clone data adapter source code

git clone https://github.com/UMSpotifyChallenge/DatabaseAdapter.git

* install dependencies

cd DatabaseAdapter

bundle install

* setting up db connection

cd config

ln -s database_flux.yml database.yml

cd ..

* then, this interactive shell should work

rails c

* try...

Playlist.count

Playlist.find(12345)

most_popular = Playlist.order(num_followers: :desc).limit(1)

most_popular.track_list

Track.find(12345)

Track.find(12345).artist

Track.find(12345).tempo
