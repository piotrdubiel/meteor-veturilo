# vi: set ft=coffee:


Meteor.startup ->
  Stations._ensureIndex({ location: "2dsphere" })

#Meteor.publish "nearest_stations", (position) ->
#  console.log(position)
#  Stations.find {location:
#      $nearSphere: [position.longitude, position.latitude]
#    },
#    limit: 20


Meteor.publish "stations", ->
  Stations.find()
