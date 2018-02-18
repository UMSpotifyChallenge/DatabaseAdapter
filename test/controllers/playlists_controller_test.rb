require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playlist = playlists(:one)
  end

  test "should get index" do
    get playlists_url
    assert_response :success
  end

  test "should get new" do
    get new_playlist_url
    assert_response :success
  end

  test "should create playlist" do
    assert_difference('Playlist.count') do
      post playlists_url, params: { playlist: { collaborative: @playlist.collaborative, duration_ms: @playlist.duration_ms, modified_at: @playlist.modified_at, name: @playlist.name, num_albums: @playlist.num_albums, num_artists: @playlist.num_artists, num_edits: @playlist.num_edits, num_followers: @playlist.num_followers, num_tracks: @playlist.num_tracks } }
    end

    assert_redirected_to playlist_url(Playlist.last)
  end

  test "should show playlist" do
    get playlist_url(@playlist)
    assert_response :success
  end

  test "should get edit" do
    get edit_playlist_url(@playlist)
    assert_response :success
  end

  test "should update playlist" do
    patch playlist_url(@playlist), params: { playlist: { collaborative: @playlist.collaborative, duration_ms: @playlist.duration_ms, modified_at: @playlist.modified_at, name: @playlist.name, num_albums: @playlist.num_albums, num_artists: @playlist.num_artists, num_edits: @playlist.num_edits, num_followers: @playlist.num_followers, num_tracks: @playlist.num_tracks } }
    assert_redirected_to playlist_url(@playlist)
  end

  test "should destroy playlist" do
    assert_difference('Playlist.count', -1) do
      delete playlist_url(@playlist)
    end

    assert_redirected_to playlists_url
  end
end
