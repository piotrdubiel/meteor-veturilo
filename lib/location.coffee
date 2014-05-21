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


@nearest = (position, limit) ->
  return Stations.find {
    location:
      $near: [
        position.longitude
        position.latitude
      ]},
    limit: limit
