(function() {
  var Keyboard, defineKeyCodeRange, pressedKeys, reactKeyDown, reactKeyUp;
  pressedKeys = {};
  reactKeyDown = function(e) {
    return pressedKeys[e.keyCode] = true;
  };
  reactKeyUp = function(e) {
    return pressedKeys[e.keyCode] = false;
  };
  Keyboard = {
    KEY_LEFT: 37,
    KEY_UP: 38,
    KEY_RIGHT: 39,
    KEY_DOWN: 40,
    KEY_RETURN: 13,
    KEY_ESPACE: 32,
    KEY_SHIFT: 16,
    KEY_CTRL: 17,
    KEY_ALT: 18,
    KEY_TAB: 9,
    keyIsDown: function(code) {
      return pressedKeys[code] === true;
    }
  };
  defineKeyCodeRange = function(chars, code, prefix) {
    var chr, _i, _len, _ref, _results;
    if (prefix == null) {
      prefix = '';
    }
    _ref = chars.split('');
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      chr = _ref[_i];
      _results.push(Keyboard["KEY_" + prefix + chr] = code++);
    }
    return _results;
  };
  defineKeyCodeRange("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 65);
  defineKeyCodeRange("0123456789", 48);
  defineKeyCodeRange("0123456789", 96, "NUM_");
  $(function() {
    $(document.body).keydown(function(e) {
      return reactKeyDown(e);
    });
    return $(document.body).keyup(function(e) {
      return reactKeyUp(e);
    });
  });
  window.KeyboardUtils = Keyboard;
}).call(this);
