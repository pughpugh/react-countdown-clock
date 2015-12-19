(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("react"));
	else if(typeof define === 'function' && define.amd)
		define(["react"], factory);
	else if(typeof exports === 'object')
		exports["ReactCountdownClock"] = factory(require("react"));
	else
		root["ReactCountdownClock"] = factory(root["React"]);
})(this, function(__WEBPACK_EXTERNAL_MODULE_1__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/build/";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var React;
	
	React = __webpack_require__(1);
	
	module.exports = React.createClass({
	  _seconds: 0,
	  _radius: null,
	  _fraction: null,
	  _content: null,
	  _canvas: null,
	  displayName: 'ReactCountdownClock',
	  propTypes: {
	    seconds: React.PropTypes.number,
	    size: React.PropTypes.number,
	    color: React.PropTypes.string,
	    alpha: React.PropTypes.number,
	    onComplete: React.PropTypes.func
	  },
	  getDefaultProps: function() {
	    return {
	      size: 300,
	      color: '#000',
	      alpha: 1
	    };
	  },
	  componentWillReceiveProps: function(props) {
	    this._seconds = props.seconds;
	    return this._setupTimer();
	  },
	  componentDidMount: function() {
	    this._seconds = this.props.seconds;
	    return this._setupTimer();
	  },
	  _setupTimer: function() {
	    this._setScale();
	    this._setupCanvas();
	    this._drawTimer();
	    return this._startTimer();
	  },
	  _updateCanvas: function() {
	    this._clearTimer();
	    return this._drawTimer();
	  },
	  _setScale: function() {
	    this._radius = this.props.size / 2;
	    this._fraction = 2 / this._seconds;
	    return this._tickPeriod = this._seconds * 1.8;
	  },
	  _setupCanvas: function() {
	    this._canvas = ReactDOM.findDOMNode(this);
	    this._context = this._canvas.getContext('2d');
	    this._context.textAlign = 'center';
	    this._context.textBaseline = 'middle';
	    return this._context.font = "bold " + (this._radius / 2) + "px Arial";
	  },
	  _startTimer: function() {
	    return setTimeout(((function(_this) {
	      return function() {
	        return _this._tick();
	      };
	    })(this)), 200);
	  },
	  _tick: function() {
	    var start;
	    start = Date.now();
	    return setTimeout(((function(_this) {
	      return function() {
	        var duration;
	        duration = (Date.now() - start) / 1000;
	        _this._seconds -= duration;
	        if (_this._seconds <= 0) {
	          _this._seconds = 0;
	          _this._handleComplete();
	          return _this._clearTimer();
	        } else {
	          _this._updateCanvas();
	          return _this._tick();
	        }
	      };
	    })(this)), this._tickPeriod);
	  },
	  _handleComplete: function() {
	    if (this.props.onComplete) {
	      return this.props.onComplete();
	    }
	  },
	  _clearTimer: function() {
	    this._context.clearRect(0, 0, this._canvas.width, this._canvas.height);
	    return this._drawBackground();
	  },
	  _drawBackground: function() {
	    this._context.beginPath();
	    this._context.globalAlpha = this.props.alpha / 3;
	    this._context.arc(this._radius, this._radius, this._radius, 0, Math.PI * 2, false);
	    this._context.arc(this._radius, this._radius, this._radius / 1.8, Math.PI * 2, 0, true);
	    return this._context.fill();
	  },
	  _drawTimer: function() {
	    var decimals, percent, ref;
	    percent = this._fraction * this._seconds + 1.5;
	    decimals = (ref = this._seconds <= 9.9) != null ? ref : {
	      1: 0
	    };
	    this._context.globalAlpha = this.props.alpha;
	    this._context.fillStyle = this.props.color;
	    this._context.fillText(this._seconds.toFixed(decimals), this._radius, this._radius);
	    this._context.beginPath();
	    this._context.arc(this._radius, this._radius, this._radius, Math.PI * 1.5, Math.PI * percent, false);
	    this._context.arc(this._radius, this._radius, this._radius / 1.8, Math.PI * percent, Math.PI * 1.5, true);
	    return this._context.fill();
	  },
	  render: function() {
	    return React.createElement("canvas", {
	      "className": "react-countdown-clock",
	      "width": this.props.size,
	      "height": this.props.size
	    });
	  }
	});


/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = __WEBPACK_EXTERNAL_MODULE_1__;

/***/ }
/******/ ])
});
;
//# sourceMappingURL=react-countdown-clock.js.map