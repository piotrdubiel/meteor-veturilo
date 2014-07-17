# vi: set ft=coffee:

Meteor.subscribe "stations"

Session.set("reload", true)

Template.stations.rendered = ->
  watch_location (position) ->
    console.log "New center #{JSON.stringify(position)}"
    if position.accuracy < 1000
      Session.set("center", position)
    else
      console.log "Skipping location due to low accuracy"

  Deps.autorun ->
    Session.set("result", stations())
    console.log "New result..."
    if Session.get("reload")
      console.log "Reloading list..."
      $('#list').empty()
      list = document.createElement("meteor-list")
      document.getElementById("list").appendChild(list)


Template.stations.link = ->
  label = "#{@.name} - #{@.bikes} bikes left"
  "#{maps_scheme()}#{@.location[1]},#{@.location[0]}(#{encodeURIComponent(label)})"

Template.navigation.streetview = ->
  streetview(Session.get("search-result") || Session.get("center") || {latitude: 52.225574, longitude: 21.010931})

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
