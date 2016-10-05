  
  # # # # # # # # # # # # # # # # # # # # # # # #
  #    THIS IS THE MAIN SCRIPT USED BY THE APP  #
  # # # # # # # # # # # # # # # # # # # # # # # #

# Event called when a ".grid-item" is clicked
gridItemOnClick = ($grid, e) ->
  e.stopPropagation()
  $el = $ e.currentTarget
  $content = $ $el.find(".content")[0]
  if $grid.find(".content:not(.hidden)").length > 0
    contentAlreadyHidden = $content.hasClass "hidden"
    hideAllContent($grid)
    if contentAlreadyHidden
      $content.removeClass("hidden")
  else
    $content.removeClass("hidden")
  setAudioPlayerState($content)
  refreshGrid($grid)
  
# Hide all .content nodes in the grid
hideAllContent = ($grid) ->
  $grid.find(".content").addClass("hidden")

# Set the src attribute of audio elements
# On initial page load, only the inert-src attribute is set.
# This is so the audio doesn't all load at once.
setAudioPlayerState = ($content) ->
  $src = $content.find("source")
  $.each $src, (idx, el) ->
    $el = $ el
    if !($el.attr("src"))
      $el.attr("src", $el.attr("inert-src"))
      $el.parent("audio")[0].load()

# Funcion called by $.isotope
# Called once for each .grid-item element
# Returns a boolean indicating whether the element
# should be visible or not
isotopeFilterFn = () ->
  $this = $ this
  tags = $this.data("tags")
  currentTag = window.currentTag
  if currentTag
    isVisible = (tags.length > 0) && tags.includes(currentTag)
  else
    isVisible = true
  if isVisible
    $this.addClass("visible-grid-item")
  else
    $this.removeClass("visible-grid-item")
  return isVisible

# Call the $.isotope function using a custom filter
# Hides elements in the grid unless they meet the filter's criteria.
filterGrid = ($grid) ->
  $grid.isotope filter: isotopeFilterFn
  
# Event called when the mouse enters a .grid-iem node
gridItemOnMouseenter = (e) ->
  $(e.currentTarget).addClass("selected-grid-item")
  
# Event called when the mouse leaves a .grid-item node
gridItemOnMouseleave = (e) ->
  $(e.currentTarget).removeClass("selected-grid-item")

# Event called when the mouse enters a .content node
togglingContentOnMouseenter = (e) ->
  $(e.currentTarget).parents(".grid-item")
                    .removeClass("selected-grid-item")

# Event called when the mouse leaves a .content node
togglingContentOnMouseleave = (e) ->
  $(e.currentTarget).parents(".grid-item")
                    .addClass("selected-grid-item")
                    
# Event called when an audio element has stopped playing
# Triggers moveToNextTrack
onAudioEnd = ($grid, e) ->
  $audio = $ e.currentTarget
  $audio[0].currentTime = 0
  $audio[0].pause()
  moveToNextTrack($grid, $audio)

# Finds the next playable audio node on the page
# Starts playing this next node and changes the UI accordingly
moveToNextTrack = ($grid, $audio) ->
  nextEl = $($audio.nextAll("audio")[0])[0]
  if nextEl
    nextEl.play()
  else
    $parentGridItem = $audio.parents(".visible-grid-item")
    $nextGridItem = $($parentGridItem.nextAll(".visible-grid-item")[0])
    if $nextGridItem
      $parentGridItem.trigger("click")
      $nextGridItem.trigger("click")
      $nextAudio = $nextGridItem.find("audio")
      if $nextAudio[0]
        $nextAudio[0].play()

# Event called when an audio node starts playing
# Stops other playing audio
onAudioPlay = ($grid, e) ->
  $audio = $(e.currentTarget)
  $.each $(".playing-audio"), (idx, el) ->
    if (el != e.currentTarget)
      $(el).removeClass "playing-audio"
      el.pause()
  $audio.addClass("playing-audio")
  e.preventDefault()

# Set up event listeners on the grid
# and call refreshGrid
setupGrid = ($grid, $gridItems, $togglingContent) ->
  $gridItems.on "click", curry(gridItemOnClick)($grid)
  $togglingContent.on "click", (e) -> e.stopPropagation()
  $togglingContent.addClass "hidden"
  $gridItems.on "mouseenter", gridItemOnMouseenter
  $gridItems.on "mouseleave", gridItemOnMouseleave
  $togglingContent.on "mouseenter", togglingContentOnMouseenter
  $togglingContent.on "mouseleave", togglingContentOnMouseleave
  $downloadAllButtons = $togglingContent.find(".download-all")
  $downloadAllButtons.on "click", curry(downloadAllButtonOnClick)($grid)
  $audio = $togglingContent.find("audio")
  $audio.on "play", curry(onAudioPlay)($grid)
  $audio.on "ended", curry(onAudioEnd)($grid)
  refreshGrid()
  
# Call $.isotope to re-draw the grid
# This is needed after grid items have their dimensions changes,
# i.e. if some hidden content becomes visible
refreshGrid = ($grid) ->
  $grid.isotope
    itemSelector: '.grid-item'
    layoutMode: 'fitRows'

# Look to the fragment of the url to determine the page state.
# i.e. if if the fragment says #album then the 'album' filter will be applied,
#      and only .grid-items tagged as 'album' will be visible
# This is so the page can be refreshed without losing all state.
loadInitialState = ($grid) ->
  currentTag = window.location.hash.replace("#", "")
  if currentTag.length > 0
    window.currentTag = currentTag
    $("[tag-name='" + currentTag + "']").addClass("selected-tag")
    filterGrid($grid)

# Event called when a .tagLink element is clicked
# Calls the isotope filter function and redraws the grid
metadataOnClick = ($grid, e) ->
  $elem = $ e.currentTarget
  tag = $elem.text()
  window.location.hash = tag
  window.currentTag = tag
  isSelected =$elem.hasClass("selected-tag")
  $(".selected-tag").removeClass("selected-tag")
  $elem.addClass("selected-tag")
  filterGrid $grid
  e.preventDefault()

# Dynamically create a #navbarTags node which contains .tagLink nodes
# Append it to #nav and set up event listeners on the .tagLink nodes
setupMetadata = ($grid, $metadata) ->
  $metadata.addClass "hidden"
  $navbarTagsMenu = buildNavbarTagsMenu $grid, $metadata
  $("#nav").append $navbarTagsMenu
  $(".tagLink").on "click", curry(metadataOnClick)($grid)

# Constructs a #navbarTags node
# and populates it with .tagLink nodes
buildNavbarTagsMenu = ($grid, $metadata) ->
  $navbarTagsMenu = $("<div id='navbarTags'></div>")
  tags = $.map $metadata, (node) ->
    $node = $ node
    nodeJson = $node.text()
    tags = JSON.parse(nodeJson)['tags']
    $node.parents(".grid-item").data "tags", tags
    tags
  tags = Array.from(new Set(tags))
  tags.forEach (tag) ->
      tagLink = $("<a></a>").html tag
                            .addClass("tagLink")
                            .attr("href", "#")
                            .attr("tag-name", tag)
      $navbarTagsMenu.append tagLink
  addButtonToShowAll $grid, $navbarTagsMenu
  return $navbarTagsMenu

# Constructs a button to turn off the active isotope filter
# Clicking this makes all .grid-item nodes visible.
# Prepends this button to the #navbarTags node
# Applies an event listener for the button
addButtonToShowAll = ($grid, $navbarTagsMenu) ->
  $button = $("<a></a>").html("all")
                        .addClass("showAllLink")
                        .attr("href", "#")
  $navbarTagsMenu.prepend($button)
  $button.on "click", curry(showAllButtonOnClick)($grid)
  
# Event called when the .showAllLink button is clicked
# Makes all .grid-item nodes visible
showAllButtonOnClick = ($grid, e) ->
  window.location.hash = ""
  window.currentTag = undefined
  $(".selected-tag").removeClass("selected-tag")
  filterGrid($grid)
  e.preventDefault()
  
# Event called when a .download-all button is clicked
# Triggers clicks on each of the .download nodes in the same .content section.
downloadAllButtonOnClick = ($grid, e) ->
  e.preventDefault()
  $el = $(e.currentTarget)
  $.each $el.parents(".content").find(".download"), (idx, btn) ->
    btn.click() # needs to be done with vanilla js not jquery
                # see http://stackoverflow.com/q/38927303/2981429

# jquery document ready function
$ () ->

  # Get some selectors from the page
  $grid            = $ ".grid"
  $gridItems       = $grid.find ".grid-item"
  $togglingContent = $gridItems.find ".content"
  $metadata        = $grid.find ".metadata"
  
  # Set up the initial page state and listeners
  setupMetadata($grid, $metadata)
  loadInitialState($grid)
  setupGrid($grid, $gridItems, $togglingContent)

    
