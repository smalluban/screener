express = require "express"
app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

assets = require 'connect-assets'

#
# APP SETUP
#
app.use assets(detectChanges: not (process.env.NODE_ENV == 'production')) # Add Connect Assets
app.use express.static(process.cwd() + '/public') # Set the public folder as static assets
app.use express.bodyParser() # bodyParser for message form
app.set 'view engine', 'jade' # Set View Engine

#
# APP ROUTES
#

recent = []

# Get root_path return index view
app.get '/*', (req, resp) ->
  resp.render 'index', recent: recent

app.post '/send', (req, resp) ->
  message = req.body.message

  io.sockets.emit "news", { text: message.text, color: message.color} 
  
  recent.shift() if recent.length > 4
  recent.push { text: message.text, date: new Date() }

  resp.redirect('/')

#
# Socket.IO
#

#
# APP START
#

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
server.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."