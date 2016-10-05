require 'byebug'

require_relative("./sources.rb")
require_relative("./import_helpers.rb")

# Downloads files and syncs the changes to web/source/
class Import
  
  extend ImportHelpers
  
  # Downloads all the files from a given source.
  # Sync web/source/
  def self.download_from_source(source)
    Sources[source].each do |name, data|
      folder_name = get_folder_name(name)
      if folder_exists_in_audio?(folder_name)
        skip(name)
      else
        create_dir_in_audio(folder_name)
        start_download(name, folder_name, data) do |*args|
          system download_command(*([source] + args))
        end
      end
      push_changes_to_website(name, folder_name, data)
    end
  end
  
end

# If this file is run as a script,
# start the process of downloading and syncing.
# Looks to scripts/sources for a list of albums and singles
if __FILE__ == $0
  `rm -rf web/source/audio/*`
  `rm -rf web/source/markdown/*`
  Import.download_from_source("bandcamp_urls")
  Import.download_from_source("youtube_urls")
end

