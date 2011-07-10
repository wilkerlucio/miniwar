(function() {
  var Connection, host;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  host = location.href.match(/:\/\/([^:\/]+)/)[1];
  Connection = (function() {
    function Connection() {
      this.socket = new WebSocket("ws://" + host + ":8080");
      this.socket.onmessage = __bind(function(message) {
        return this.dispatch(JSON.parse(message.data));
      }, this);
      this.binds = [];
    }
    Connection.prototype.bind = function(callback) {
      return this.binds.push(callback);
    };
    Connection.prototype.dispatch = function(data) {
      var bind, _i, _len, _ref, _results;
      _ref = this.binds;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bind = _ref[_i];
        _results.push(bind(data));
      }
      return _results;
    };
    Connection.prototype.send = function(type, data) {
      var message;
      message = {
        type: type,
        data: data
      };
      message = JSON.stringify(message);
      return this.socket.send(message);
    };
    return Connection;
  })();
  window.Connection = Connection;
}).call(this);
