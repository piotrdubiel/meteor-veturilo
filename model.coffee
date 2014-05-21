# vi: set ft=coffee:

root = exports ? this
root.Stations = new Meteor.Collection "stations"

if Meteor.isServer
  Stations._ensureIndex({ location: "2dsphere" })

root.Stations.allow(
  insert: (userId, station) -> false
  update: (userId, station, fields, modifier) -> false
  remove: (userId, station) -> false
)
