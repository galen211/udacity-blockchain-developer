exports.id = "main";
exports.modules = {

/***/ "./build/contracts/FlightSuretyApp.json":
false,

/***/ "./src/server/config.json":
false,

/***/ "./src/server/server.js":
/*!******************************!*\
  !*** ./src/server/server.js ***!
  \******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var babel_polyfill__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! babel-polyfill */ \"babel-polyfill\");\n/* harmony import */ var babel_polyfill__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(babel_polyfill__WEBPACK_IMPORTED_MODULE_0__);\nfunction asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }\n\nfunction _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, \"next\", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, \"throw\", err); } _next(undefined); }); }; }\n\n // Define workspace variables\n\nvar network = \"localhost\";\nvar config = Config[network];\nvar web3 = new Web3(new Web3.providers.WebsocketProvider(config.url.replace(\"http\", \"ws\")));\nvar flightSuretyApp = new web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);\nvar ORACLES_COUNT = 20;\nvar FIRST_ORACLE_ADDRESS;\nvar LAST_ORACLE_ADDRESS; // This is an IIFE (Immediately invoked function expression) just to provide this `async` keyword\n\n_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {\n  var accounts, fee;\n  return regeneratorRuntime.wrap(function _callee$(_context) {\n    while (1) {\n      switch (_context.prev = _context.next) {\n        case 0:\n          _context.next = 2;\n          return web3.eth.getAccounts();\n\n        case 2:\n          accounts = _context.sent;\n          FIRST_ORACLE_ADDRESS = accounts.length - ORACLES_COUNT - 1;\n          LAST_ORACLE_ADDRESS = ORACLES_COUNT + FIRST_ORACLE_ADDRESS;\n          console.log(\"Ganache returned \".concat(accounts.length, \" accounts.\"));\n          console.log(\"Server will use only \".concat(ORACLES_COUNT, \" of these accounts for oracles.\"));\n          console.log(\"Starting from accounts[\".concat(FIRST_ORACLE_ADDRESS, \"] for the first oracle.\"));\n          console.log(\"Ending at accounts[\".concat(LAST_ORACLE_ADDRESS, \"] for the last oracle.\")); // Use `.call` to fetch the current registration fee value\n\n          _context.next = 11;\n          return flightSuretyApp.methods.REGISTRATION_FEE().call({\n            \"from\": accounts[0],\n            \"gas\": 4712388,\n            \"gasPrice\": 100000000000\n          });\n\n        case 11:\n          fee = _context.sent;\n          console.log(\"Smart Contract requires \".concat(fee, \" wei to fund oracle registration.\")); // Register all available oracles using the `accounts` array and await the process to finish\n\n          _context.next = 15;\n          return Promise.all(accounts.map(function (account) {\n            return flightSuretyApp.methods.registerOracle().send({\n              \"from\": account,\n              \"value\": fee,\n              \"gas\": 4712388,\n              \"gasPrice\": 100000000000\n            });\n          }));\n\n        case 15:\n          console.log(\"Oracles server all set-up...\\nOracles registered and assigned addresses...\");\n          console.log(\"Listening to a request event...\"); // Once all oracles are registered we can start listening to oracle requests\n\n          flightSuretyApp.events.OracleRequest({\n            \"fromBlock\": \"latest\"\n          }, function (error, event) {\n            if (error) {\n              console.log(error);\n            } else {\n              // @TODO You have to assign the random status code and submit the `submitOracleResponse` within this block.\n              console.log(event);\n            }\n          });\n\n        case 18:\n        case \"end\":\n          return _context.stop();\n      }\n    }\n  }, _callee);\n}))(); // Simple HTTP server using express.js, you don't have to worry about it\n\n\nvar app = express();\napp.get(\"/api\", function (req, res) {\n  res.send({\n    message: \"An API for use with your Dapp!\"\n  });\n});\n/* harmony default export */ __webpack_exports__[\"default\"] = (app);\n\n//# sourceURL=webpack:///./src/server/server.js?");

/***/ }),

/***/ "babel-polyfill":
/*!*********************************!*\
  !*** external "babel-polyfill" ***!
  \*********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"babel-polyfill\");\n\n//# sourceURL=webpack:///external_%22babel-polyfill%22?");

/***/ }),

/***/ "express":
false,

/***/ "web3":
false

};