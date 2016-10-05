#!/usr/bin/env ruby

# ######################################################
# Thile file should be run from the web/ directory.
# It can be run with no arguments, which will create
# a markdown file in web/source/markdown unless one already
# exists.
# If required, the Seed.create(name: "", content: "", tags: [])
# API can be used
# ######################################################

# Dependencies
require 'nokogiri'
require 'open-uri'

# Creates markdown files in web/source/markdown/
module Seed
  
  # Given 'name', 'content', and 'tags', options,
  # create a markdown files in web/source/markdown/
  def self.create(options={})
    name, content, tags = options.values_at(:name, :content, :tags)
    raise ArgumentError unless [name, content].all? { |x| x.is_a?(String) && x.length > 0 }
    raise ArgumentError unless tags.is_a?(Array) && tags.length > 0
    path = "./web/source/markdown/#{name}.md.erb"
    metadata_string = "**METADATA**\nTAGS: #{tags.join(", ")}\n****\n"
    File.open(path, 'w') { |file| file.write("#{metadata_string}#{content}") }
  end
  
end

# Block called if this file is being run directly
if __FILE__ == $0
  
  # Create a sample markdown file if none exist
  if Dir.glob("./**/*.md.erb").count == 0
    Seed.create(
      name: "sample page click me",
      content: "#### It's a markdown page",
      tags: ["sample tag"]
    )
    puts "Seeded a sample markdown page"
  end
  
end
