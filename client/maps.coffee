# vi: set ft=coffee:

Meteor.subscribe("stations")

get_location = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (loc) ->
      position = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude
        accuracy: loc.coords.accuracy
      }
      #Meteor.subscribe("nearest_stations", position)
      console.log "Subscribed to nearest stations"
      Session.set("location", position)

Meteor.startup ->
  get_location()

Template.maps.rendered = ->
  Deps.autorun ->
    position = Session.get("location") || {latitude: 52.225574, longitude: 21.010931}
    
    if Deps.currentComputation.firstRun
      $("#map").css("height", $(window).height())
      @maps = new Maps($("#map"), position, {zoom: 14})
    
    @maps.clear()
    Stations.find().forEach (station) =>
      @maps.add_marker(
        latitude: station.location[1]
        longitude: station.location[0]
        title: station.name
        icon: {
          url: "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1|0|FF0000|16|_|#{station.bikes}"
          scaledSize: new google.maps.Size(42, 68)
        }
      )
    @maps.add_marker(Session.get "location") if Session.get "location"

Template.stations.list = ->
  Stations.find()
