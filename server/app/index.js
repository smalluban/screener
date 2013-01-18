// Generated by CoffeeScript 1.4.0
var app, assets, express, io, port, recent, server;

express = require("express");

app = express();

server = require('http').createServer(app);

io = require('socket.io').listen(server);

assets = require('connect-assets');

app.use(assets({
  detectChanges: !(process.env.NODE_ENV === 'production')
}));

app.use(express["static"](process.cwd() + '/public'));

app.use(express.bodyParser());

app.set('view engine', 'jade');

recent = [];

app.get('/*', function(req, resp) {
  return resp.render('index', {
    recent: recent
  });
});

app.post('/send', function(req, resp) {
  var message;
  message = req.body.message;
  io.sockets.emit("news", {
    text: message.text,
    color: message.color
  });
  if (recent.length > 4) {
    recent.shift();
  }
  recent.push({
    text: message.text,
    date: new Date()
  });
  return resp.redirect('/');
});

port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

server.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
