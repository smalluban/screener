# Main App controller
class App extends Spine.Controller
  elements:
    ".message": "message"
    "#box": "box"
    "iframe": "iframe"

  offer: null
  color: 0
  server: "http://mars.activeweb.pl:8888"

  escapeDiacritics: (text)->
    text.replace(/ą/g, 'a').replace(/Ą/g, 'A')
      .replace(/ć/g, 'c').replace(/Ć/g, 'C')
      .replace(/ę/g, 'e').replace(/Ę/g, 'E')
      .replace(/ł/g, 'l').replace(/Ł/g, 'L')
      .replace(/ń/g, 'n').replace(/Ń/g, 'N')
      .replace(/ó/g, 'o').replace(/Ó/g, 'O')
      .replace(/ś/g, 's').replace(/Ś/g, 'S')
      .replace(/ż/g, 'z').replace(/Ż/g, 'Z')
      .replace(/ź/g, 'z').replace(/Ź/g, 'Z')

  constructor: ->
    super

    #Setup part
    @message.css('fontSize', ($(window).height() / 4) + "px")

    href = window.location.search.replace(/^\?/,'')

    if href == ""
      url = prompt("URL","")
      window.location.href = "/?" + url


    @iframe.attr "src", "http://" +  href 

    # Voice function
    meSpeak.loadConfig "mespeak/mespeak_config.json"
    meSpeak.loadVoice "mespeak/voices/pl.json"

    # Socket 
    @socket = io.connect @server 

    # Clear message screen
    @socket.on 'clear', ()=>
      clearTimeout @offer

      @box.removeAttr "data-color"
      @message.removeAttr "data-state"

    # put new message on screen
    @socket.on 'news',(data)=>
      clearTimeout @offer
      time = parseInt data.time

      @message.removeAttr "data-state"
      @box.removeAttr "data-color"

      setTimeout(
        ()=>  
          @box.attr "data-color", data.color
          meSpeak.speak @escapeDiacritics("uwaga! " + data.text), amplitude: 180, wordgap: 3, pitch: 30, speed: 140
          @message.text data.text
          @message.attr "data-state", "in"
        , 1500)

      if time > 0
        @offer = setTimeout(
          ()=>
            @box.removeAttr "data-color"
            @message.removeAttr "data-state"
          , data.time * 60 * 1000)

# Start application after document is ready 
# and connect it with body tag
$(document).ready ->
  exports.app = new App({el: $("body")});