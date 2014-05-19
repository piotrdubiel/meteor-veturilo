# vi: set ft=coffee:

class @Maps
  constructor: (container, position, options) ->
    center = new google.maps.LatLng(position.latitude, position.longitude)
    delete options["center"] if options
    options = $.extend {
      styles: [{"stylers": [{ "invert_lightness": true }, { "saturation": 30 }]}]
      center: center
      scrollwheel: true
      draggable: true
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }, options || {}
    element = container.get(0)
    @map = new google.maps.Map(element, options)
    @markers = []

  add_marker: (request) ->
    latlng = new google.maps.LatLng(request.latitude, request.longitude)
    marker = new google.maps.Marker(
      position: latlng
      map: @map
      title: request.title
      icon: request.icon || "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
    )
    if request.accuracy
      radius = new google.maps.Circle(
        map: @map
        radius: request.accuracy
        fillColor: "#d62728"
        fillOpacity: 0.35
        strokeColor: "#d62728"
        strokeWeight: 1
        strokeOpacity: 0.7
        animation: google.maps.Animation.DROP,
      )
      radius.bindTo("center", marker, "position")

    @markers.push(marker)
    return marker

  clear: ->
    @markers.forEach (marker) ->
      marker.setMap(null)
    @markers = []

  center: (position) ->
    @map.setCenter(new google.maps.LatLng(position.latitude, position.longitude))
