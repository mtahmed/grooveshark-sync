# Standard imports
require 'highline/import'
require 'xmlrpc/client'

# Custom imports
require 'grooveshark'
require_relative 'settings'

# Normalize the name of the song.
# This name is also used as a filename for the song.
def normalize_name(name)
  return name.gsub(/[-_.\s]+/, '_').downcase
end

# Login the user defined by username, password.
def login_user(gs_client, username, password)
  begin
    user = gs_client.login(username, password)
  rescue Grooveshark::InvalidAuthentication
    puts "Wrong username or password!"
  end
  return user
end

# MAIN
if __FILE__ == $PROGRAM_NAME
  gs_client = Grooveshark::Client.new()
  aria2_server = XMLRPC::Client.new('localhost', '/rpc', 6800)
  cwd = Dir.pwd()

  # If not username/password is defined in the settings file, prompt for
  # username/password.
  if USERNAME.empty? and PASSWORD.empty?
    username = ask("Username: ") { |q| q.echo = true }
    password = ask("Password: ") { |q| q.echo = '*' }
  else
    username = USERNAME
    password = PASSWORD
  end

  begin
    user = login_user(gs_client, username, password)
  rescue Grooveshark::InvalidAuthentication
    puts "Wrong username or password."
    exit 1
  end

  for playlist in user.playlists do
    playlist_dir = File.join(cwd, playlist.name)
    printf("Syncing playlist %s ...\n", playlist.name)
    unless File.directory?(playlist_dir)
      Dir.mkdir(playlist_dir)
    end

    playlist.load_songs()
    songs = playlist.songs
    for song in songs
      normalized_song_name = normalize_name(song.name)
      song_filename = normalized_song_name + '.mp3'
      song_file = File.join(playlist_dir, song_filename)
      # Download the song if it doesn't already exist.
      unless File.exist?(song_file)
        song_url = gs_client.get_song_url(song)
        aria2_server.call('aria2.addUri',
                          [song_url],
                          {dir: playlist_dir, out: song_filename})
        printf("  Downloading song %s\n", song.name)
      end
    end
  end
end
