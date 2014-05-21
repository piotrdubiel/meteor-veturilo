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
