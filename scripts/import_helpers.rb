require 'colored'
require 'mp3info'

require_relative("../web/seed.rb")

# included by Import
# assists in downloading music listed in scripts/sources.rb
# populates audio/, web/source/markdown/ and web/source/audio/
module ImportHelpers
  
  # transforms a string's non-alphaneumeric characters into underscores
  def get_folder_name(name)
    name.gsub(/[^a-zA-Z1-9\_]/) { |x| "_" }
  end
  
  # Check if audio/ contains a specified folder
  def folder_exists_in_audio?(folder_name)
    `ls audio/ | grep #{folder_name}`.chomp.length > 0
  end
  
  # Creates a folder in audio/
  def create_dir_in_audio(folder_name)
    `mkdir audio/#{folder_name}`
  end
  
  # Method called when a dir already exists in audio/
  # prints a message saying it's being skipped
  def skip(name)
    puts pretty_console_block("DIR ALREADY EXISTS; SKIPPING: #{name}", :yellow)
  end
  
  # formats into a string into a flashy ascii box
  def pretty_console_block(text, custom_delimiter_color=nil)
    line_width = 20
    result = ""
    delimiter = "\n#{"-" * line_width}\n"
    colored_delimiter = delimiter.send(custom_delimiter_color&.to_sym || :green)
    result += colored_delimiter
    result += text.rjust(line_width / 2).ljust(line_width)
    result += colored_delimiter
    result
  end
  
  # Initiate a context in which to download files
  # Does not necessarily trigger any downloads
  # The actual download command and should be called
  # in the block given
  def start_download(name, folder_name, url, &blk)
    puts pretty_console_block("\n\ndownloading #{name}\n\n")
    begin
      blk.call(name, folder_name, url)
      begin
        give_metadata(name, folder_name, url)
      rescue Exception => e
        puts pretty_console_block("error setting metadata for #{name}")
      end
    rescue Exception => e
      handle_download_error(name, folder_name, url, e)
    end
  end
  
  # From the given 'name' string, determine 'artist' and 'album' metadata
  # This has no effect unless the 'name' follows a specific format, either:
  #  1. "artist name _ALBUM_ album name"
  #  2. "artist name _SINGLE_ track name"
  # Applies this metadata to the mp3 files
  def give_metadata(name, folder_name, url)
    album_parts = name.split(" _ALBUM_ ")
    single_parts = name.split(" _SINGLE_ ")
    album_parts, single_parts = [album_parts, single_parts].map do |parts_set|
      (parts_set.length < 2) ? nil : parts_set
    end
    artist, album = album_parts || single_parts
    Dir.glob("./audio/#{folder_name}/**/*.mp3").each do |path|
      Mp3Info.open(path) do |mp3|
        mp3.tag.artist = artist
        mp3.tag.album = "#{album_parts ? "ALBUM" : "SINGLE"} #{album}"
      end
    end
  end
  
  # An error to display when a download files
  # should be followed with gets.chomp
  def download_error_text(name, error)
    error_str = ""
    error_str += "FAILED TO DOWNLOAD #{name}\n"
    error_str += "ERROR: #{error} #{error.message}\n"
    error_str += "WHAT TO DO?\n"
    error_str += "type 'y' to remove folder and contents\n"
    error_str += "type 'backtrace' to see backtrace\n"
    error_str
  end
  
  # Removes a folder in audio/ if it exists
  def remove_folder_in_audio(folder_name)
    if Dir.exists? "./audio/#{folder_name}"
      `rm -rf ./audio/#{folder_name}`
    end
  end
  
  # Removes a folder in web/source/audio if it exists
  def remove_folder_in_web_source_audio(folder_name)
    if Dir.exists? "./web/source/audio/#{folder_name}"
      `rm -rf ./web/source/audio/#{folder_name}`
    end
  end
  
  # Called when a download error occurs.
  # Prompts the user to determine the next action
  def handle_download_error(name, folder_name, url, error)
    puts pretty_console_block(download_error_text(name, error), :red)
    case gets.chomp
    when 'y'
      remove_folder_in_audio(folder_name)
      puts pretty_console_block("REMOVED FOLDER. EXITING")
    when 'backtrace'
      puts pretty_console_block("#{error.backtrace}\n\nPRINTED BACKTRACE. EXITING")
    end
  end
  
  # Determine the right download command
  def download_command(src, name, folder_name, data)
    url = data[:url]
    if src.to_s == "bandcamp_urls"
      download_bandcamp_url(folder_name, url)
    elsif src.to_s == "youtube_urls"
      download_youtube_url(folder_name, url)
    end
  end
  
  # The system command for downloading an album from bandcamp.
  # Isn't executed here
  def download_bandcamp_url(folder_name, url)
    "cd audio/#{folder_name} && ruby ../../scripts/bandcamp_downloader/bandcamp_downloader.rb #{url}"
  end
  
  # The system command for downloading an album from youtube.
  # Isn't executed here
  def download_youtube_url(folder_name, url)
    "ruby ./scripts/youtube-audio-downloader/youtube-audio.rb url #{url} ./audio/#{folder_name}"
  end
  
  # All audio file paths in the audio/ directory
  def audio_files(folder_name)
    Dir.glob("./audio/#{folder_name}/**/*")
  end

  # Given a string, change all spaces into underscores
  def sanitize_path(path)
    if path.include?(" ")
      new_path = path.gsub(" ", "_")
      `mv "#{path}" #{new_path}`
      path = new_path
    end
    path
  end
  
  # From a path, find the name of the file
  def file_name_from_path(path)
    path.split("/")[-1]
  end
  
  # The path given to clients.
  # Points to files made publicly accessible by the static server.
  def public_path(folder_name, file_name)
    "./audio/#{folder_name}/#{file_name}"
  end
  
  # The HTML for a single file in the web interface
  # Includes an audio player and download button
  # Note that the <audio> element will not load automatically.
  # On the client, Javascript will copy the inert-src attribute into src
  def file_listing_html_string(file_path, file_name)
    "<audio controls>" +
      "<source inert-src='#{file_path}' type='audio/mpeg'>" +
    "</audio>" +
    "<a class='download'" +
      "href='#{file_path}'" +
      "download='#{file_name}'" +
    ">download</a>"
  end
  
  # Makes a HTML section containing all the files in a folder
  def file_listings_html_string(file_paths, folder_name)
    file_paths.map do |path|
      dist_file_name = file_name_from_path(sanitize_path(path))
      dist_final_path = public_path(folder_name, dist_file_name)
      next file_listing_html_string(dist_final_path, dist_file_name)
    end.join("<br>")
  end
  
  # A HTML string which contains a file_listings_html_string
  # as well as a "download all" button
  def complete_section_content_html_string(file_listings)
    "<a class='download-all' href='#'>" +
      "Download all" +
    "</a><br>" +
    file_listings
  end
  
  # Copies a folder from audio/ into web/source/audio/
  def copy_audio_to_web_source(folder_name)
    `cp -r ./audio/#{folder_name}/ ./web/source/audio/`
  end
  
  # Removes a file in web/source/markdown/ if it exists
  def remove_section_markdown_file(file_name)
    if File.exists? "./web/source/markdown/#{file_name}.md.erb"
      `rm ./web/source/markdown/#{file_name}.md.erb`
    end
  end
  
  # Goes through all the mp3 files in audio and sanitizes each of their paths.
  # Changes all non-alphaneumeric characters into underscores.
  # Calls 'mv' to make these changes permanent.
  def fix_files
    Dir.glob("./audio/**/*.mp3").each do |path|
      file_name = file_name_from_path(path)
      proper_file_name = file_name.gsub(/[^a-zA-Z1-9\_\.]/) { |char| "_" }
      unless file_name == proper_file_name
        `mv "#{path}" #{path.gsub(file_name, proper_file_name)}`
      end
    end
  end
  
  # When an album or single is finished downloading,
  # this method is called to sync web/source/
  def push_changes_to_website(name, folder_name, data)
    fix_files
    remove_folder_in_web_source_audio(folder_name)
    file_listings = file_listings_html_string(audio_files(folder_name), folder_name)
    content = complete_section_content_html_string(file_listings)
    copy_audio_to_web_source(folder_name)
    remove_section_markdown_file(folder_name)
    tags = data[:tags]
    Seed.create(name: folder_name, content: content, tags: tags )
  end
  
end
