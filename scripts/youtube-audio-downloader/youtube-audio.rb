require 'spinning_cursor'
require 'byebug'

puts "\nYoutube Audio Downloader"


args = []
while ARGV.any?
  args.push ARGV.shift
end

# CLI Arguments
if args[0] == "playlist"
  is_playlist = true
elsif args[0] == "url"
  urls = [args[1]]
  dest_path = args[2]
else
  # Initial URL prompt
  puts "Enter a video URL and press enter:"
  urls = [gets.chomp]

  # Additional URLs prompt
  more_urls_prompt =  "\nIf there are no more URLs, press enter; otherwise, enter another URL and press enter:"
  puts more_urls_prompt
  until (next_url = gets.chomp).empty?
    urls << next_url
    puts more_urls_prompt
  end
end

# URL sanitation
urls = urls.map do |url|
	if url.match(/^www/)
		"https://" + url
	else
		url
	end
end

unless defined?(dest_path)
  # Destination folder prompt
  puts "\n Where should the mp3 files be saved? To use the default (~/Downloads), press enter without typing anything. To use the current directory, press . (period). To use any other directory, enter an absolute path."
  destination_cmd = gets.chomp
  dest_path = case destination_cmd
  when ""
     "~/Downloads"
  when "."
     `pwd`.chomp
  else
     destination_cmd
  end
end


# Download execution
urls = urls
destination_path = dest_path
puts "OK, downloading #{urls.length} track(s) to #{destination_path}."
urls.each_with_index do |url, index|
  SpinningCursor.run do
	banner "downloading"
	type :spinner
	delay 0.10
	action do
	  if is_playlist
	    `cd #{destination_path} && youtube-dl --extract-audio --prefer-ffmpeg --audio-format mp3 --yes-playlist --audio-quality 3 #{url} >/dev/null`
	  else
	    `cd #{destination_path} && youtube-dl --extract-audio --prefer-ffmpeg --audio-format mp3 --audio-quality 3 #{url} >/dev/null`
	  end
	end
	message "#{index + 1} downloaded"
  end
end

puts "done"   

