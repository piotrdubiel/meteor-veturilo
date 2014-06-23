# vi: set ft=coffee:

class @Maps
  constructor: (container, position, options) ->
    center = new google.maps.LatLng(position.latitude, position.longitude)
    delete options["center"] if options
    styles = [
      {
        featureType: "road.arterial"
        elementType: "geometry"
        stylers: [
          { hue: "#00ffee" }
          { saturation: 50 }
        ]
      },
      {
        featureType: "poi.business"
        elementType: "labels"
        stylers: [
          { visibility: "off" }
        ]
      }
      {
        featureType: "administrative"
        stylers: [
          { hue: "#ff0000" }
          { saturation: 100 }
        ]
      }
    ]
    options = $.extend {
      styles: styles
      center: center
      scrollwheel: true
      draggable: true
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }, options || {}
    element = container.get(0)
    @map = new google.maps.Map(element, options)
    @markers = []

  addMarker: (request) ->
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

  markerWithTitle: (title) ->
    _.find(@markers, (marker) -> marker.getTitle() == title)

  markerWithPosition: (position) ->
    _.find(@markers, (marker) ->
      marker.getPosition().lat() == position.latitude && marker.getPosition().lng() == position.longitude
    )

  removeMarkerWithTitle: (title) ->
    @markerWithTitle(title).setMap(null)

  clear: ->
    @markers.forEach (marker) ->
      marker.setMap(null)
    @markers = []

  center: (position) ->
    @map.setCenter(new google.maps.LatLng(position.latitude, position.longitude))

  getCenter: ->
    center = @map.getCenter()
    {latitude: center.lat(), longitude: center.lng()}

  zoom: (val) ->
    @map.setZoom(val)


  circle: (point) ->
    radius = google.maps.geometry.spherical.computeDistanceBetween(
      new google.maps.LatLng(point.latitude, point.longitude),
      @map.getCenter()
    )

    circle = new google.maps.Circle(
      map: @map
        radius: radius
        fillColor: "#333333"
        fillOpacity: 0.35
        strokeColor: "#d62728"
        strokeWeight: 1
        strokeOpacity: 0.7
        center: @map.getCenter()
    )

  onCenterChanged: (listener) ->
    google.maps.event.addListener(@map, 'center_changed', listener)
