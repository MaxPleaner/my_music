require 'ostruct'

Sources = OpenStruct.new(
  bandcamp_urls: {},
  youtube_urls: {}
)

def bandcamp_url(name=nil, url=nil, *tags)
  raise ArgumentError unless [name, url, tags].all?
  Sources.bandcamp_urls[name] = { url: url, tags: tags }
end

def youtube_url(name=nil, url=nil, *tags)
  raise ArgumentError unless [name, url, tags].all?
  Sources.youtube_urls[name] = { url: url, tags: tags }
end

# ======================================================================= #
# What follows is a long list of urls to download                         #
# ======================================================================= #

bandcamp_url "vektor _ALBUM_ terminal redux",
"https://vektor.bandcamp.com/album/terminal-redux",
"metal", "album", "prog"

# bandcamp_url "dissonant protean _ALBUM_ space loops lite",
# "http://dissonant-protean.bandcamp.com",
# "homemade", "beats", "album"

# bandcamp_url "grindbot _ALBUM_ nonsense covers",
# "https://grindbot.bandcamp.com/album/nonsense-covers-tv-movies",
# "metal", "electro", "grindcore", "album", "prog"

# bandcamp_url "atriarch _ALBUM_ forever the end",
# "http://releases.seventhrule.com/album/forever-the-end",
# "doom", "black-metal", "album"

# youtube_url "sonic _SINGLE_ game over remix",
# "https://www.youtube.com/watch?v=ZhnVZPPYNHU",
# "video-game", "sonic", "beats", "single"

# youtube_url "pokemon _SINGLE_ wild encounter metal cover",
# "https://www.youtube.com/watch?v=8KhCgmQ4hew",
# "video-game", "pokemon", "metal", "single"

# youtube_url "pokemon _ALBUM_ all wild battle themes",
# "https://www.youtube.com/watch?v=sH1uHBwfRcA",
# "pokemon", "video-game", "album"

# youtube_url "pokemon _ALBUM_ all trailer battle themes",
# "https://www.youtube.com/watch?v=ybTL7mI6K2M",
# "pokemon", "video-game", "album"

# bandcamp_url "king kraken _ALBUM_ fancy studio session",
# "https://kingkraken.bandcamp.com/",
# "homemade", "ska", "album"

# bandcamp_url "dead set _ALBUM_ alien nation",
# "https://deadset1.bandcamp.com/",
# "punk", "homemade", "album"

# youtube_url "voivod _ALBUM_ nothingface",
# "https://www.youtube.com/watch?v=Wa80CBbc-lg",
# "rock", "album", "prog"

# youtube_url "voivod _ALBUM_ phobos",
# "https://www.youtube.com/watch?v=QPW9tKA_O7A",
# "rock", "album", "prog"

# youtube_url "voivod _ALBUM_ the outer limits",
# "https://www.youtube.com/watch?v=0UwRBb08wI4",
# "rock", "album", "prog"

# youtube_url "voivod _ALBUM_ angel rat",
# "https://www.youtube.com/watch?v=YaUcAKe03vo",
# "rock", "album", "prog"

# youtube_url "voivod _ALBUM_ negatron",
# "https://www.youtube.com/watch?v=1QcqBU9riA8",
# "rock", "album", "prog"

# youtube_url "melt banana _ALBUM_ fetch",
# "https://www.youtube.com/watch?v=xBU5dyv-Tjo",
# "punk", "electro", "album", "grindcore"

# bandcamp_url "cauldron black ram _ALBUM_ stalagmire",
# "http://listen.20buckspin.com/album/stalagmire",
# "metal", "album"

# bandcamp_url "coelecanth _ALBUM_ demo",
# "https://coelacanthmetal.bandcamp.com/",
# "metal", "album"

# bandcamp_url "the impalers _ALBUM_ Psychedelic Snutskallar",
# "https://theimpalers.bandcamp.com/album/psychedelic-snutskallar",
# "metal", "album"

# bandcamp_url "the imalers _ALBUM_ 2013 LP",
# "https://theimpalers.bandcamp.com/album/lp",
# "metal", "album"

# youtube_url "radiohead _SINGLE_ dollars and cents",
# "https://www.youtube.com/watch?v=d2_QtTa732Q",
# "rock", "chill", "radiohead", "single"

# youtube_url "radiohead _SINGLE_ i might be wrong",
# "https://www.youtube.com/watch?v=vOa--Dhu11M",
# "rock", "chill", "radiohead", "single"

# youtube_url "radiohead _SINGLE_ pyramid song",
# "https://www.youtube.com/watch?v=3M_Gg1xAHE4",
# "rock", "chill", "radiohead", "single"

# youtube_url "radiohead _SINGLE_ paranoid android",
# "https://www.youtube.com/watch?v=fHiGbolFFGw",
# "rock", "radiohead", "single"

# youtube_url "radiohead _SINGLE_ fake plastic trees",
# "https://www.youtube.com/watch?v=n5h0qHwNrHk",
# "chill", "feels", "radiohead", "single"

# youtube_url "radiohead _SINGLE_ daydreaming",
# "https://www.youtube.com/watch?v=TTAU7lLDZYU",
# "chill", "radiohead", "single"

# youtube_url "metal covers _SINGLE_ rihanna we found love djent",
# "https://www.youtube.com/watch?v=m9J6K56dga8",
# "djent", "metal", "cover", "single"

# youtube_url "katy perry _SINGLE_ fireworks djent cover",
# "https://www.youtube.com/watch?v=__bg-HIV5YU",
# "djent", "metal", "cover", "single"

# youtube_url "katy perry _SINGLE_ teenage dream metal cover",
# "https://www.youtube.com/watch?v=KIZGJnFJnsU",
# "metal", "cover", "single"

# youtube_url "u2 and periphery _SINGLE_ sunday bloody sunday metal cover",
# "https://www.youtube.com/watch?v=l45TbwnFgSQ",
# "metal", "cover", "djent", "single"

# youtube_url "drewsif stalin and tay vonday _SINGLE_ chocolate rain metal cover",
# "https://www.youtube.com/watch?v=zP0dDr3my_o",
# "metal", "djent", "cover", "single"

# youtube_url "tim and eric _SINGLE_ jews rock",
# "https://www.youtube.com/watch?v=k06lLDDe-b4",
# "random", "single"

# youtube_url "anal cunt _ALBUM_ fuckin a",
# "https://www.youtube.com/watch?v=27nnqCVNLTA",
# "punk", "album", "rock"

# youtube_url "haggus _ALBUM_ haggus and recalcitrant split",
# "https://www.youtube.com/watch?v=k61hJwKO_IE",
# "grindcore", "album"

# youtube_url "old lady drivers _ALBUM_ formula",
# "https://www.youtube.com/watch?v=SRDXt2lcoCE",
# "elecro", "album"

# youtube_url "old lady drivers _ALBUM_ lo flux tube",
# "https://www.youtube.com/watch?v=YMATyXP4cEs",
# "electro", "album", "prog"

# youtube_url "virus _ALBUM_ the black flux",
# "https://www.youtube.com/watch?v=QVXfaxjEJwU",
# "rock", "prog", "album"

# youtube_url "virus _ALBUM_ carheart",
# "https://www.youtube.com/watch?v=Z7w_SSFfDkI",
# "rock", "album", "prog"

# youtube_url "virus _ALBUM_ oblivion clock",
# "https://www.youtube.com/watch?v=G-M4aOO95dI",
# "rock", "album", "prog"

# youtube_url "spastic ink _ALBUM_ ink complete",
# "https://www.youtube.com/watch?v=X5SWc_k_Hmk",
# "metal", "album", "prog"

# youtube_url "captured by robots _SINGLE_ dont stop believin",
# "https://www.youtube.com/watch?v=iyOzcg7liVc",
# "cover", "rock", "single"

# bandcamp_url "keenan cunnin _ALBUM_ donald trump remix",
# "https://keenancunnin.bandcamp.com/album/the-trump-tapes",
# "beats", "album"

# bandcamp_url "colosso _ALBUM_ abrasive peace",
# "http://music.colossometal.com/album/abrasive-peace",
# "metal", "prog", "grindcore", "album"

# bandcamp_url "language ltd _ALBUM_ the end is etc",
# "https://languageltd.bandcamp.com/album/the-end-is-etc",
# "rock", "psych", "album"

# bandcamp_url "recalibrator _ALBUM_ the omniscient one",
# "https://recalibrater.bandcamp.com/album/the-omniscient-one",
# "metal", "djent", "album"

# bandcamp_url "eat the sun _ALBUM_ expand and collide",
# "https://eatthesunband.bandcamp.com/album/expand-and-collide",
# "prog", "rock", "album",

# bandcamp_url "diascorium _ALBUM_ abstractions of the absolute",
# "https://diascorium.bandcamp.com/album/abstractions-of-the-absolute",
# "metal", "black metal", "album"

# bandcamp_url "tron maximum _ALBUM_ berzerker generator",
# "https://tronmaximum.bandcamp.com/album/berserker-generator",
# "electro", "grindcore", "album"

# bandcamp_url "yeah great fine _ALBUM_ asterisk",
# "https://yeahgreatfine.bandcamp.com/album/-",
# "rock", "prog"

# bandcamp_url "the ancient eternal _ALBUM_ aurora",
# "https://theancienteternal.bandcamp.com/album/aurora",
# "beats", "chill", "album"

# bandcamp_url "kamasumatra _ALBUM_ chemtrails",
# "https://larrystepniak.bandcamp.com/album/chemtrails",
# "noise", "album", "chill"

# bandcamp_url "kamasutara _ALBUM_ surveillance",
# "https://larrystepniak.bandcamp.com/album/surveillance",
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ false flag",
# "https://larrystepniak.bandcamp.com/album/false-flag"
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ tranquility base",
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ new ocean drone",
# "https://larrystepniak.bandcamp.com/album/new-ocean",
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ stepping stone",
# "https://larrystepniak.bandcamp.com/album/stepping-stone",
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ under the glitches spell",
# "https://larrystepniak.bandcamp.com/album/under-the-glitches-spell",
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ splicophony",
# "https://larrystepniak.bandcamp.com/album/spliciphony",
# "rock", "chill", "album"

# bandcamp_url "kamasutara _ALBUM_ the church of american prosperity and health",
# "https://larrystepniak.bandcamp.com/album/the-church-of-american-prosperity-and-health",
# "noise", "album"

# bandcamp_url "kamasutara _ALBUM_ step 4",
# "https://larrystepniak.bandcamp.com/album/step-4",
# "prog", "rock", "album"

# bandcamp_url "brandon _ALBUM_ prismatic world",
# "https://ilovebrandon.bandcamp.com/album/prismatic-world-ep",
# "video-game", "beats", "electro", "album"

# bandcamp_url "vingthor the hurler _ALBUM_ low budget lo fi",
# "https://vingthorthehurler.bandcamp.com/album/low-budget-lofi-series-vol-1",
# "beats", "album", "electro"

# bandcamp_url "breakmaster cylinder _ALBUM_ picked beets II",
# "https://breakmastercylinder.bandcamp.com/album/pickled-beets-part-ii",
# "beats", "electro"

# bandcamp_url "icytwat _ALBUM_ cyber palace",
# "https://icytwat.bandcamp.com/album/cyber-palace",
# "beats", "chill", "album", "electro"

# bandcamp_url "the mad bitter _ALBUM_ webcome to the madhouse",
# "https://themadbitter.bandcamp.com/album/welcome-to-the-madhouse",
# "album", "chiptune", "electro", "beats"

# bandcamp_url "kola kid _ALBUM_ rave to the grade",
# "https://kolakid.bandcamp.com/album/rave-to-the-grave",
# "album", "chiptune", "electro", "beats"
