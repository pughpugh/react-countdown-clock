React  = require 'react'

_radius   = null
_fraction = null
_context  = null
_canvas   = null

module.exports = React.createClass
  propTypes:
    seconds: React.PropTypes.number
    size: React.PropTypes.number
    color: React.PropTypes.string
    alpha: React.PropTypes.number
    onComplete: React.PropTypes.func

  getDefaultProps: ->
    seconds: 60
    size: 300
    color: '#000'
    alpha: 1

  getInitialState: ->
    seconds: @props.seconds

  componentWillReceiveProps: (props) ->
    @setState seconds: props.seconds

  componentWillMount: ->
    @_setScale()

  componentDidMount: ->
    @_setupCanvas() if !_canvas
    @_drawTimer()
    @_startTimer()

  componentDidUpdate: ->
    @_setScale()
    @_clearTimer()
    @_drawTimer()
    if @state.seconds <= 0
      @_handleComplete()

  _setScale: ->
    _radius   = @props.size / 2
    _fraction = 2 / @props.seconds

  _setupCanvas: ->
    _canvas  = @getDOMNode()
    _context = _canvas.getContext '2d'
    _context.textAlign = 'center'
    _context.textBaseline = 'middle'
    _context.font = "bold #{_radius/2}px Arial"

  _startTimer: ->
    # Give it a moment to collect it's thoughts for smoother render
    setTimeout ( => @_tick() ), 200

  _tick: ->
    start = Date.now()
    setTimeout ( =>
      duration = Date.now() - start
      @setState
        seconds: @state.seconds - duration / 1000
      @_tick() unless @state.seconds <= 0
    ), 30

  _handleComplete: ->
    @setState seconds: 0
    if @props.onComplete
      @props.onComplete()

  _clearTimer: ->
    _context.clearRect 0, 0, _canvas.width, _canvas.height
    @_drawBackground()

  _drawBackground: ->
    _context.beginPath()
    _context.globalAlpha = @props.alpha / 3
    _context.arc _radius, _radius, _radius,     0,           Math.PI * 2, false
    _context.arc _radius, _radius, _radius/1.8, Math.PI * 2, 0,           true
    _context.fill()

  _drawTimer: ->
    percent = _fraction * @state.seconds + 1.5
    decimals = (@state.seconds <= 9.9) ? 1 : 0
    _context.globalAlpha = @props.alpha
    _context.fillStyle = @props.color
    _context.fillText @state.seconds.toFixed(decimals), _radius, _radius
    _context.beginPath()
    _context.arc _radius, _radius, _radius,     Math.PI * 1.5,     Math.PI * percent, false
    _context.arc _radius, _radius, _radius/1.8, Math.PI * percent, Math.PI * 1.5,     true
    _context.fill()

  render: ->
    <canvas className="react-countdown-clock" width={@props.size} height={@props.size}></canvas>
