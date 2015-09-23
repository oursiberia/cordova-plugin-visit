var exec = require('cordova/exec');

var Visit = {

  startMonitoring: function(arg0, success, error) {
    exec(success, error, "Visit", "startMonitoring", [arg0]);
  }

};

module.exports = Visit;
