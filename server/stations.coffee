# vi: set ft=coffee:


Meteor.publish "stations", ->
  Stations.find()
