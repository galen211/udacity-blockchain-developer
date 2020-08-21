var test = require('tape');
var hex2ascii = require('../hex2ascii');

test('hex2ascii', function (t) {
  t.plan(10)

  t.equal(hex2ascii(''), '')
  t.equal(hex2ascii({}), '')
  t.equal(hex2ascii(function(){}), '')
  t.equal(hex2ascii(function(){}), '')
  t.equal(hex2ascii(31323334), '1234')
  t.equal(hex2ascii('68656c6c6f'), 'hello')
  t.equal(hex2ascii('0x68656c6c6f'), 'hello')
  t.equal(hex2ascii('0x68656c6c6f20776f726c64'), 'hello world')
  t.equal(hex2ascii('20 20 20 20 20 68 65 6c 6c 6f 20 20 20 20 20'), '     hello     ')
  t.equal(hex2ascii('0x66696e646d656275727269746f732e636f6d0000000000000000000000000000'), 'findmeburritos.com')
})
