require 'i18n/langs' # for multi language support, comment this line if unused

# Main App controller
class App extends Spine.Controller
  elements:
    ".message": "message"
    "#box": "box"
    "iframe": "iframe"

  offer: null
  color: 0
  server: "http://mars.activeweb.pl:8888"

  constructor: ->
    super

    #Setup part
    @message.css('fontSize', ($(window).height() / 4) + "px")

    href = window.location.search.replace(/^\?/,'')

    if href == ""
      url = prompt("URL","")
      window.location.href = "/?" + url


    @iframe.attr "src", "http://" +  href 

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