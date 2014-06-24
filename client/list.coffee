# vi: set ft=coffee:

Meteor.subscribe "stations"

Template.stations.rendered = ->
  watch_location (position) ->
    console.log "New center #{JSON.stringify(position)}"
    Session.set("center", position)

Template.stations.list = ->
  if Session.get("match-query")
    matching(Session.get("match-query"), 50)
  else
    position = Session.get("search-result") || Session.get("center") || {latitude: 52.225574, longitude: 21.010931}
    nearest(position, 50)

Template.station.height = ->
  "#{Math.floor($(window).height() / 20)}px"

Template.station.count = ->
  parseInt(@.bikes)

Template.station.link = ->
  label = "#{@.name} - #{@.bikes} bikes left"
  "#{maps_scheme()}#{@.location[1]},#{@.location[0]}(#{encodeURIComponent(label)})"

Template.navigation.events =
  "keyup #search-input":  (event) ->
    text = $("#search-input").val()
    if event.keyCode == 13
      geocode text
    else if text.length > 0
      console.log text
      Session.set("match-query", text)
    else
      Session.set("match-query", null)

  "click #search-button": (event) ->
    event.preventDefault()
    geocode $("#search-input").val()
