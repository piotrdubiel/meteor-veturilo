# vi: set ft=coffee:

Template.stations.list = ->
  position = Session.get("center") || {latitude: 52.225574, longitude: 21.010931}
  nearest(position, 20)

Template.station.height = ->
  "#{Math.floor($(window).height() / 20)}px"

Template.station.count = ->
  parseInt(@.bikes)

Template.station.events =
  "click tr": ->
    window.maps.center({latitude: @.location[1], longitude: @.location[0]})
    window.maps.zoom(15)