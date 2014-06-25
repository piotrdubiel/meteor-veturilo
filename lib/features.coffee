# vi: set ft=coffee:

platform =
  Android: ->
      /Android/i.test(navigator.userAgent)
  BlackBerry: ->
      /BlackBerry/i.test(navigator.userAgent)
  iOS: ->
      /iPhone|iPad|iPod/i.test(navigator.userAgent)
  Windows: ->
      /IEMobile/i.test(navigator.userAgent)
  any: ->
      (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows())

@maps_scheme = ->
  if platform.Android()
    "geo:0,0?q="
  else
    "http://maps.google.com/maps?q="
