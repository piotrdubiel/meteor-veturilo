# vi: set ft=coffee:

Meteor.subscribe "stations"

Session.set("reload", true)
    
transition = (event) ->
  if (Session.get("page") == 0)
    Session.set("selected", @)
    Session.set("page", 1)
  else
    Session.set("page", 0)
    event.stopPropagation()

  console.log Session.get("page")

Template.stations.rendered = ->
  watch_location (position) ->
    console.log "New center #{JSON.stringify(position)}"
    if position.accuracy < 1000
      Session.set("center", position)
    else
      console.log "Skipping location due to low accuracy"

Template.stations.list = ->
  if Session.get("match-query")
    matching(Session.get("match-query"), 10)
  else
    position = Session.get("search-result") || Session.get("center") || {latitude: 52.225574, longitude: 21.010931}
    nearest(position, 10)

Template.stations.page = ->
  Session.get("page") || 0

Template.stations.transition = ->
  console.log "a"


Template.station.is_selected = ->
  @ == selected

Template.stations.link = ->
  label = "#{@.name} - #{@.bikes} bikes left"
  "#{maps_scheme()}#{@.location[1]},#{@.location[0]}(#{encodeURIComponent(label)})"

Template.station.latitude = ->
  @.location[1]

Template.station.longitude = ->
  @.location[0]

Template.navigation.streetview = ->
  streetview(Session.get("search-result") || Session.get("center") || {latitude: 52.225574, longitude: 21.010931})

Template.stations.events =
  "click station-card": (event) ->
    transition event

  "click #close": (event) ->
    console.log "Template"
    transition event

Template.navigation.events =
  "search-changed search-input": (event) ->
    text = event.originalEvent.detail.text
    console.log text
    if text.length > 0
      Session.set("match-query", text)
    else
      Session.set("match-query", null)
      Session.set("search-result", null)

  "search-tapped search-input": (event) ->
    text = event.originalEvent.detail.text
    geocode text
