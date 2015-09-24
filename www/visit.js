var exec = require('cordova/exec');

var Visit = {

  startMonitoring: function(success, error) {
    exec(success, error, "Visit", "startMonitoring");
  }

};

module.exports = Visit;
