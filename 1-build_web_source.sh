#!/usr/bin/bash

  # # # # # # # # # # # # # # # # # # # # # # # #
  # STEP ONE OF THE BUILD / DEPLOY PROCESS      #
  # # # # # # # # # # # # # # # # # # # # # # # #

# Downloads files listed in scrips/sources.rb
# Syncs the changes to web/source/
ruby scripts/import.rb

