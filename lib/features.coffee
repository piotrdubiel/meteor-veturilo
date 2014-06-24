# vi: set ft=coffee:

platform =
  Android: ->
      return /Android/i.test(navigator.userAgent)
  BlackBerry: ->
      return /BlackBerry/i.test(navigator.userAgent)
  iOS: ->
      return /iPhone|iPad|iPod/i.test(navigator.userAgent)
  Windows: ->
      return /IEMobile/i.test(navigator.userAgent)
  any: ->
      return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows())

@maps_scheme = ->
  console.log navigator.userAgent
  if platform.Android()
    return "geo:0,0?q="
  else
    return "http://maps.google.com/maps?q="
