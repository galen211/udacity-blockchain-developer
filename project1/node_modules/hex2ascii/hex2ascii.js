;(function(root) {
  'use strict'

  function hex2ascii (hex) {
    if (!(typeof hex === 'number' || typeof hex == 'string')) {
      return ''
    }

    hex = hex.toString().replace(/\s+/gi, '')
    const stack = []

    for (var i = 0; i < hex.length; i += 2) {
      const code = parseInt(hex.substr(i, 2), 16)
      if (!isNaN(code) && code !== 0) {
        stack.push(String.fromCharCode(code))
      }
    }

    return stack.join('')
  }

  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = hex2ascii
    }
    exports.hex2ascii = hex2ascii
  } else if (typeof define === 'function' && define.amd) {
    define([], function() {
      return hex2ascii
    })
  } else {
    root.hex2ascii = hex2ascii
  }
})(typeof window !== 'undefined' ? window : this);
