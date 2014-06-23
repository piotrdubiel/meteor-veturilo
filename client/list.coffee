# vi: set ft=coffee:

Meteor.startup ->
  Deps.autorun ->
    Session.set("active", Session.get("active") || "stations")

Template.stations.rendered = ->
  Deps.autorun ->
    if Session.get "active" == "stations"
      $("#stations").addClass("active")
      $("#maps").removeClass("active")
    else if Session.get "active" == "maps"
      $("#maps").addClass("active")
      $("#stations").removeClass("active")

Template.stations.list = ->
  if Session.get("match-query")
    matching(Session.get("match-query"), 50)
  else
    position = Session.get("center") || {latitude: 52.225574, longitude: 21.010931}
    nearest(position, 50)

Template.station.height = ->
  "#{Math.floor($(window).height() / 20)}px"

Template.station.count = ->
  parseInt(@.bikes)

Template.station.events =
  "click tr": ->
    window.maps.center({latitude: @.location[1], longitude: @.location[0]})
    window.maps.zoom(15)

Template.navigation.link = ->
  if Session.get("active") == "stations"
    "maps"
  else
    "stations"

Template.navigation.icon = ->
  if Session.get("active") == "stations"
    "fi-marker"
  else
    "fi-list"

Template.navigation.events =
  "keyup #search-input":  (event) ->
    text = $("#search-input").val()
    if event.keyCode == 13
      geocode text
    else if text.length > 0
      Session.set("match-query", text)
    else
      Session.set("match-query", null)

  "click #search-button": (event) ->
    event.preventDefault()
    geocode $("#search-input").val()

  "click #toggle": ->
    if Session.get("active") == "stations"
      Session.set("active", "maps")
    else
      Session.set("active", "stations")
