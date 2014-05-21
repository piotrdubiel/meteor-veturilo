# vi: set ft=coffee:

Meteor.subscribe("stations")

Template.maps.rendered = ->
  Deps.autorun ->
    position = Session.get("location") || {latitude: 52.225574, longitude: 21.010931}
    
    if Deps.currentComputation.firstRun
      $("#map").css("height", $(window).height() - $(".tab-bar").height())
      @maps = new Maps($("#map"), position, {zoom: 14})
    
    @maps.clear()
    Stations.find().forEach (station) =>
      @maps.add_marker(
        latitude: station.location[1]
        longitude: station.location[0]
        title: station.name
        #icon: "http://maps.google.com/mapfiles/ms/icons/yellow-dot.png"
        icon: {
          url: "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1|0|FF0000|16|_|#{station.bikes}"
          scaledSize: new google.maps.Size(42, 68)
        }
      )
    get_location (position) ->
      @maps.add_marker(position)
      @maps.center(position)
      edge = Stations.findOne { location: { $near: [position.longitude, position.latitude]}}, { limit: 20 }
      @maps.circle({latitude: edge.location[1], longitude: edge.location[0]})

      
