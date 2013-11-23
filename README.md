# grooveshark-sync

Allows you to sync all your grooveshark playlists to your local harddrive.

## Installation

```bash
gem install grooveshark
cd ~/bin
hg clone https://bitbucket.org/mtahmed/grooveshark-sync
# OR
git clone https://github.com/mtahmed/grooveshark-sync.git
```

To avoid having to type out the username/password everytime, edit the
`settings.rb` file to add your username and password.

## Usage

```bash
ruby grooveshark-sync/grooveshark_sync.rb
```

## Dependencies
- ruby
- [grooveshark ruby api](https://github.com/sosedoff/grooveshark)
- [aria2](http://aria2.sourceforge.net/)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mtahmed/grooveshark-sync/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

