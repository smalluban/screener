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
app.locals.moment = require('moment') # set moment parser to jade templating system
app.locals.moment.lang "pl"
#

# BASIC AUTH
#

auth = express.basicAuth(
  (user, pass)-> 
    user == 'screener' and pass == 'pass123'
  ,'Admin Area')

#
# MAILER SETUP
#

email = require('emailjs').server.connect
  user:    "connectmedica@activeweb.pl"
  password:"ska487r32we"
  host:    "mail.activeweb.pl"
  ssl:     false

#
# APP ROUTES
#

recent = []
color = 0

# Get root_path return index view
app.get '/', auth, (req, resp) ->
  resp.render 'index', recent: recent

app.get '/clear', auth, (req, resp) ->
  io.sockets.emit "clear"

  recent.shift() if recent.length > 4
  recent.push { text: "Czyściciel...", date: new Date() }

  resp.redirect '/'

app.post '/send', auth, (req, resp) ->
  message = req.body.message
  color = (color + 1) % 4

  io.sockets.emit "news", { text: message.text, time: message.time, color: color } 

  if message.mail
    email.send
      text:    message.text
      from:    "Kanapki <kanapki@connectmedica.com>"
      to:      "Connectmedica <kanapki@connectmedica.com>"
      subject: message.text
      , (err, message) -> 
        console.log err or message
  
  recent.shift() if recent.length > 4
  recent.push { text: message.text, date: new Date() }

  resp.redirect '/'

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