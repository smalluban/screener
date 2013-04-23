(function() {
  var app, express, port;

  express = require('express');

  app = express();

  app.use(express["static"](process.cwd() + '/public'));

  port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

  app.listen(port, function() {
    return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
  });

}).call(this);
