require 'i18n/langs' # for multi language support, comment this line if unused

# Main App controller
class App extends Spine.Controller
  elements:
    ".message": "message"
    "#box": "box"
    "iframe": "iframe"

  offer: null
  color: 0

  constructor: ->
    super
    @log "Hello there! I am your Spine App"

    name = prompt("URL","")

    @iframe.attr "src", name

    @socket = io.connect 'http://10.1.2.14:3000' 

    @socket.on 'news',(data)=>
      clearTimeout @offer

      @message.removeAttr "data-state"
      @box.removeAttr "data-color"

      setTimeout(
        ()=>
          @box.attr "data-color", @color
          @message.text data.text
          @message.attr "data-state", "in"
          @color = (@color + 1) % 4
        , 1500)


      @offer = setTimeout(
        ()=>
          @box.removeAttr "data-color"
          @message.removeAttr "data-state"
        , 90 * 1000)

# Start application after document is ready 
# and connect it with body tag
$(document).ready ->
  exports.app = new App({el: $("body")});