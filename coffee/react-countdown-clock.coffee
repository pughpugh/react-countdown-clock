React  = require 'react'

timeoutIds = []

module.exports = React.createClass
  _seconds: 0
  _radius: null
  _fraction: null
  _content: null
  _canvas: null
  
  propTypes:
    seconds: React.PropTypes.number
    size: React.PropTypes.number
    color: React.PropTypes.string
    alpha: React.PropTypes.number
    onComplete: React.PropTypes.func

  getDefaultProps: ->
    size: 300
    color: '#000'
    alpha: 1

  componentWillReceiveProps: (props) ->
    @_seconds = props.seconds
    @_setupTimer()

  componentDidMount: ->
    @_seconds = @props.seconds
    @_setupTimer()

  componentWillUnmount: ->
    for timeout in timeoutIds
      clearTimeout(timeout)

  _setupTimer: ->
    @_setScale()
    @_setupCanvas()
    @_drawTimer()
    @_startTimer()

  _updateCanvas: ->
    @_clearTimer()
    @_drawTimer()

  _setScale: ->
    @_radius     = @props.size / 2
    @_fraction   = 2 / @_seconds
    @_tickPeriod = @_seconds * 1.8

  _setupCanvas: ->
    @_canvas  = @getDOMNode()
    @_context = @_canvas.getContext '2d'
    @_context.textAlign = 'center'
    @_context.textBaseline = 'middle'
    @_context.font = "bold #{@_radius/2}px Arial"

  _startTimer: ->
    # Give it a moment to collect it's thoughts for smoother render
    timeoutIds.push(setTimeout ( => @_tick() ), 200)

  _tick: ->
    start = Date.now()
    timeoutIds.push(setTimeout ( =>
      duration = (Date.now() - start) / 1000
      @_seconds -= duration

      if @_seconds <= 0
        @_seconds = 0
        @_handleComplete()
        @_clearTimer()
      else
        @_updateCanvas()
        @_tick()
    ), @_tickPeriod)

  _handleComplete: ->
    if @props.onComplete
      @props.onComplete()

  _clearTimer: ->
    @_context.clearRect 0, 0, @_canvas.width, @_canvas.height
    @_drawBackground()

  _drawBackground: ->
    @_context.beginPath()
    @_context.globalAlpha = @props.alpha / 3
    @_context.arc @_radius, @_radius, @_radius,     0,           Math.PI * 2, false
    @_context.arc @_radius, @_radius, @_radius/1.8, Math.PI * 2, 0,           true
    @_context.fill()

  _drawTimer: ->
    percent = @_fraction * @_seconds + 1.5
    decimals = (@_seconds <= 9.9) ? 1 : 0
    @_context.globalAlpha = @props.alpha
    @_context.fillStyle = @props.color
    @_context.fillText @_seconds.toFixed(decimals), @_radius, @_radius
    @_context.beginPath()
    @_context.arc @_radius, @_radius, @_radius,     Math.PI * 1.5,     Math.PI * percent, false
    @_context.arc @_radius, @_radius, @_radius/1.8, Math.PI * percent, Math.PI * 1.5,     true
    @_context.fill()

  render: ->
    <canvas className="react-countdown-clock" width={@props.size} height={@props.size}></canvas>
