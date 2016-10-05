#!/usr/bin/bash
  
  # # # # # # # # # # # # # # # # # # # # # # # #
  # STEP TWO OF THE BUILD / DEPLOY PROCESS      #
  # # # # # # # # # # # # # # # # # # # # # # # #

# Generates web/dist/ folder based on web/source/
cd web
ruby gen.rb

# Deploys web/dist/ to S3 static website host
cd dist
aws s3 sync . s3://my-music
cd ../../