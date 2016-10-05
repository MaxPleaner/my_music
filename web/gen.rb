#!/usr/bin/env ruby

require 'byebug'
require 'slim'
require 'sass'
require 'coffee-script'
require 'rerun'
require 'webrick'


# Helpers module has instance methods made available to templates
require_relative("./helpers.rb")

# PartialNotFoundError is raised when a partial is not found
# The Helpers#render method can trigger this
# Slim partial filenames need to begin with an underscore
class PartialNotFoundError < StandardError; end
  
# Compiles web/source/ into web/dist/
class Gen
  
  # A block is called when the script is run
  # Compiles web/source/ into web/dist/
  # If no file paths are given in ARGV, compile everything.
  # Otherwise, only compile the specified files.
  Block_To_Run_When_Script_Is_Started = ->() {
    gen = Gen.new
    FILES_TO_RUN = ARGV.map { ARGV.shift }
    if FILES_TO_RUN.empty?
      gen.refresh_gen_out_dir.compile_all
    else
      FILES_TO_RUN.each { |path| gen.preprocess_any_single_file(path) }
    end
  }
  
  # Gen is initialized with no arguments
  attr_reader :gen_out_dir
  def initialize
    self.class.class_exec { include Helpers }
    @gen_out_dir = get_gen_out_dir
  end
  
  # Recompiles web/source/ to web/dist/ in entirety
  def compile_all
    preprocess_scripts
    preprocess_styles
    preprocess_slim
    copy_mp3
    self
  end
  
  # Deletes and recreates some folders web/dist/
  # Doesn't remove web/dist/audio/ files unless it needs to
  # Although copying all files into web/dist/audio/ is fast,
  # It changes file fingerprints and makes S3 deploys much slower.
  def refresh_gen_out_dir
    `rm -rf #{gen_out_dir}index.html`
    `rm -rf #{gen_out_dir}scripts`
    `mkdir #{gen_out_dir}scripts`
    `rm -rf #{gen_out_dir}styles`
    `mkdir #{gen_out_dir}styles`
    unless Dir.exists?("#{gen_out_dir}/audio")
      `mkdir #{gen_out_dir}audio`
    end
    self
  end
  
  # copies web/source/*.mp3 files to `web/dist/`, preserving the directory structure
  # does not change dist/audio/ any more than it needs to
  # to ensure that s3 / git sync times are low.
  def copy_mp3
    exclude_dist_folder(Dir.glob("./**/*.mp3")).each do |source_path|
      dist_path = source_path.gsub("source", "dist").split("/")[0..-2].join("/")
      source_file_name = filename_from_path(source_path)
      unless File.directory?(dist_path)
        `mkdir #{dist_path}`
      end
      unless File.exists?("#{dist_path}/#{source_file_name}")
        `cp #{source_path} #{dist_path}`
      end
    end
  end
  
  # Compiles a .slim file into .html
  def preprocess_slim
    slim_files.each { |file| preprocess_slim_file_and_save(file) }
    self
  end
  
  # Compiles a .sass file into .css
  def preprocess_styles
    sass_files.each { |file| preprocess_sass_file_and_save(file) }
    css_files.each { |file| copy_css_file(file) }
    self
  end
  
  # Compiles a .coffee file into .js
  def preprocess_scripts
    coffee_files.each { |file| preprocess_coffee_file_and_save(file) }
    js_files.each { |file| copy_js_file(file) }
    self
  end
  
  # based on the filename, determine how to preprocess a file
  # Call the preprocessor and save the result into web/dist/
  def preprocess_any_single_file(path)
    case filename_from_path(path).split(".")[1..-1].join
    when "coffee"
      preprocess_coffee_file_and_save(path)
    when "sass"
      preprocess_sass_file_and_save(path)
    when "slim"
      # since slim files can have nested templates, recompile them all
      preprocess_slim
    when "js"
      copy_js_file(path)
    when "css"
      copy_css_file(path)
    else
      compile_all
    end
    self
  end

  private
  
  # Array of file paths for all .css files in web/source/
  def css_files
    exclude_dist_folder(Dir.glob("./**/*.css"))
  end
  
  # Array of file paths for all .js files in web/source/
  def js_files
    exclude_dist_folder(Dir.glob("./**/*.js"))
  end
  
  # Copy a .js file in web/source/ into web/dist/scripts
  # No precompilation occurs
  def copy_js_file(path)
    `cp #{path} #{gen_out_dir}scripts/#{filename_from_path(path)}`
  end
  
  # Copy a .css file in web/source/ into web/dist/styles
  # No precompilation occurs
  def copy_css_file(path)
    `cp #{path} #{gen_out_dir}styles/#{filename_from_path(path)}`
  end
  
  # filter an array of filepaths to exclude the web/dist/ directory
  def exclude_dist_folder(filepaths_array) # => array
    filepaths_array.reject { |path| path.include?("dist/") }
  end
  
  # get an absolute path for the local web/dist/ folder
  def get_gen_out_dir # => string
    ENV["GEN_OUT_DIR"] || File.join(`pwd`.chomp, "dist/")
  end
  
  # preprocess a .sass file and save to web/dist/ as .css
  def preprocess_sass_file_and_save(path) # => nil
    dest_path = "#{gen_out_dir}styles/#{filename_from_path(path).gsub(".sass", ".css")}"
    File.open(dest_path, 'w') { |f| f.write Sass::Engine.new(File.read(path)).render }
    nil
  end
  
  # preprocess a .coffee file and save to web/dist/ as .js
  def preprocess_coffee_file_and_save(path) # => nil
    dest_path = "#{gen_out_dir}scripts/#{filename_from_path(path).gsub(".coffee", ".js")}"
    File.open(dest_path, 'w') { |f| f.write CoffeeScript.compile(File.read(path)) }
    nil
  end
  
  # An array of filepaths for all .slim files in web/source/
  def slim_files # => array
    exclude_partials(exclude_dist_folder(Dir.glob("./**/*.slim")))
  end
  
  # An array of filepaths for all .sass files in web/source/
  def sass_files # => array
    exclude_dist_folder(Dir.glob("./**/*.sass"))
  end
  
  # filter filepaths array to exclude partials,
  # i.e. files beginning with an underscore
  def exclude_partials(filepaths_array) # => array
    filepaths_array.reject { |path| filename_from_path(path)[0] == "_" }
  end
  
  # An array of filepaths for all .coffee files in web/source/
  def coffee_files # => array
    exclude_dist_folder(Dir.glob("./**/*.coffee"))
  end
  
  # gets the filename from a file path.
  # i.e. foo.txt from /my/path/foo.txt
  def filename_from_path(path) # => string or nil
    path.split("/")[-1]
  end

  # preprocess .slim file and save in web/dist/ as .html
  def preprocess_slim_file_and_save(source) # => nil
    destination = "#{gen_out_dir}#{filename_from_path(source).gsub("slim", "html")}"
    File.open(destination, 'w') { |file| file.write(preprocess_slim_file(source)) }
    nil
  end

  # preprocess a .slim file to an html string
  def preprocess_slim_file(source) # => string
    Tilt.new(source, {pretty: true}).render(self)
  end

end

# Start the compile process is this script is executed directly, i.e. ruby gen.rb
# if it's loaded using 'require', this block will not run.
Gen::Block_To_Run_When_Script_Is_Started.call if __FILE__ == $0
