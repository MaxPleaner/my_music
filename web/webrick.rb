#!/usr/bin/env ruby

# ######################################################
# This script should be run from inside the web/ directory.
# It starts a static server on port 8000
# The static server shows files in the dist/ folder
# ######################################################

# A static server included in ruby's standard library
require 'webrick'

# Instantiate a new server
Server = WEBrick::HTTPServer.new(
  port: 8000,
  DocumentRoot: `pwd`.chomp + '/web/dist'
)

# Start the server
# This is a blocking process
Server.start