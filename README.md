### About

There are two branches here: _master_ and _gh-pages_ - both serve a different purpose.

_master_ contains the source code, but not the audio files themselves or the produced static site. However, It does contain a script to download a user-specified list of audio files from youtube or bandcamp and can generate a static site in the process.

_gh-pages_ is a static site hosted at [maxpleaner.github.io/my-music](maxpleaner.github.io/my-music). It is a web interface for listening to and downloading the music.

Since the final product is a static website, it can be pushed to most any hosting provider. I've chosen to go with AWS s3, and have my music deployed at  [http://my-music.s3-website-us-west-1.amazonaws.com/](http://my-music.s3-website-us-west-1.amazonaws.com/)

### How to use

_note that all these commands should be run in the repo's root dir unless specified_

- clone the repo
- run bundle install, point the repo to your own git remote
- edit the [`scripts/sources.rb`](./scripts/sources.rb) file to point to your favorite music sources.
- then run [`scripts/import.rb`](./scripts/import.rb)
- `cd web` and `ruby gen.rb` to compile the static website
- `cd ..web/dist` and run of the following to deploy:
  - `git push origin HEAD:gh-pages` for github pages (easy, free). To do this, make a new git repo inside `dist/` pointing at the same origin as the main repo and commit.
  -  `aws s3 sync . s3://MY_S3_BUCKET_NAME` (free, a little more difficult). I prefer doing this because it removes the necessity to track `dist/` in git (the change
- visit website, listen to music, click download buttons

### How its build

It uses my [youtube_audio_downloader](http://github.com/maxpleaner/youtube_audio_downloader)
and [bandcamp_downloader](http://github.com/maxpleaner/bandcamp_downloader) projects.

It also uses my [static](http://github.com/maxpleaner/static) framework.

The main piece this repo adds to glue those together is the [scripts/import.rb](./scripts/import.rb) file and [scripts/import_helpers.rb](./scripts/import_helpers.rb)

### Notes

Many files are excluded from git tracking, this is so the repo doesn't blow up in size.

The following directories are included in the root level `.gitignore`

- `audio/**/*`
- `web/source/markdown/**/*`
- `web/source/audio/**/*`
- `web/dist/**/*`

Which basically leaves `scripts/sources.rb` as the only trackable source file.

The list of songs contained in this file are the only seed needed for the app. [`scripts/import.rb`](./scripts/import.rb) will download the songs and [`web/gen.rb`](./web/gen.rb) generates the website.

I've chosen to deploy this to S3 instead of github pages so that I don't worry about hitting the ceiling on Github pages' storage limits.
