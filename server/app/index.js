// Generated by CoffeeScript 1.4.0
var app, assets, auth, color, email, express, io, port, recent, server;

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

app.locals.moment = require('moment');

app.locals.moment.lang("pl");

auth = express.basicAuth(function(user, pass) {
  return user === 'screener' && pass === 'pass123';
}, 'Admin Area');

email = require('emailjs').server.connect({
  user: "connectmedica@activeweb.pl",
  password: "ska487r32we",
  host: "mail.activeweb.pl",
  ssl: false
});

recent = [];

color = 0;

app.get('/', auth, function(req, resp) {
  return resp.render('index', {
    recent: recent
  });
});

app.get('/clear', auth, function(req, resp) {
  io.sockets.emit("clear");
  if (recent.length > 4) {
    recent.shift();
  }
  recent.push({
    text: "Czyściciel...",
    date: new Date()
  });
  return resp.redirect('/');
});

app.post('/send', auth, function(req, resp) {
  var message;
  message = req.body.message;
  color = (color + 1) % 4;
  io.sockets.emit("news", {
    text: message.text,
    time: message.time,
    color: color
  });
  if (message.mail) {
    email.send({
      text: message.text,
      from: "Kanapki <kanapki@connectmedica.com>",
      to: "Connectmedica <kanapki@connectmedica.com>",
      subject: message.text
    }, function(err, message) {
      return console.log(err || message);
    });
  }
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
