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
  queries = ({name:{$regex: q, $options: "i"}} for q in query.split(" "))

  return Stations.find {
      $and: queries
    },
    limit: limit

@geocode = (address) ->
  geocoder = new google.maps.Geocoder()
  if not address.match(/warszawa/i)
    address += " warszawa"
  console.log address
  geocoder.geocode {'address': address}, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      Session.set("match-query", null)
      Session.set("search-result", {
        latitude: results[0].geometry.location.lat()
        longitude: results[0].geometry.location.lng()
      })

@streetview = (position) ->
  "http://maps.googleapis.com/maps/api/streetview?size=640x640&location=#{position.latitude},#{position.longitude}" if position
