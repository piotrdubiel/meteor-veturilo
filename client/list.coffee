# vi: set ft=coffee:

Meteor.startup ->
  get_location (position) ->
    Meteor.subscribe("stations")
    console.log "Subscribed to nearest stations"
    Session.set("location", position) if position.accuracy < 3000


Template.stations.list = ->
  position = Session.get("location") || {latitude: 52.225574, longitude: 21.010931}
  nearest(position, 20)

Template.station.height = ->
  "#{Math.floor($(window).height() / 20)}px"

Template.station.count = ->
  parseInt(@.bikes)

Template.station.events =
  "click tr": ->
    window.maps.center({latitude: @.location[1], longitude: @.location[0]})
    window.maps.zoom(15)
