### Bandcamp Downloader

Tested with Ruby 1.9.3 and Ruby 2.4.0

Dependencies:
  - depends on `mechanize` and `colored` gems being installed.

To use the CLI script:
  - `require` the program (from irb or another file) to load the BandcampDownloader class without executing anything.
  - run the program with no arguments to be prompted for a url
  - run the program with a url argument to download mp3s from the url
      - i.e. `ruby bandcamp_downloader.rb http://fullemployment.bandcamp.com` (one of my bands).
  - the files will be downloaded into whatever directory the scripwt was called from.  
      - i.e. if I call `ruby scripts/bandcamp_downloade.rb <url>` from `~/Downloads` then the files will be downloaded to `~/Downloads`. 
  - Unfortunately, the names of the tracks aren't included with the download. I might try and fix this. The files
    include the album/band name though. 
             
- When installing this program to a new machine I create a `band` alias so that I can download albums
- with `band <album>` from the terminal.
