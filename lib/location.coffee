# vi: set ft=coffee:

@get_location = (callback) ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (loc) ->
      position = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude
        accuracy: loc.coords.accuracy
      }

      callback(position) if callback

@watch_location = (success, error) ->
  if navigator.geolocation
    callback = (loc) ->
      position = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude
        accuracy: loc.coords.accuracy
      }

      success(position) if success
   navigator.geolocation.watchPosition callback, error, {timeout: 10000}


@nearest = (position, limit) ->
  return Stations.find {
    location:
      $near: [
        position.longitude
        position.latitude
      ]},
    limit: limit

@matching = (query, limit) ->
  return Stations.find {
    name:
      $regex: query
      $options: "i"
    },
    limit: limit

@geocode = (address) ->
  geocoder = new google.maps.Geocoder()
  console.log address
  geocoder.geocode {'address': address}, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      Session.set("match-query", null)
      Session.set("center", {
        latitude: results[0].geometry.location.lat()
        longitude: results[0].geometry.location.lng()
      })
      window.maps.center(Session.get("center"))
      window.maps.zoom(16)
    else
      alert("Geocode was not successful for the following reason: " + status)
