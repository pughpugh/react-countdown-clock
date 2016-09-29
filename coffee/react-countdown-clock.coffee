React  = require 'react'

module.exports = React.createClass
  _seconds: 0
  _radius: null
  _fraction: null
  _content: null
  _canvas: null
  _timeoutIds: []

  displayName: 'ReactCountdownClock'

  propTypes:
    seconds: React.PropTypes.number
    size: React.PropTypes.number
    weight: React.PropTypes.number
    color: React.PropTypes.string
    fontSize: React.PropTypes.string
    font: React.PropTypes.string
    alpha: React.PropTypes.number
    timeFormat: React.PropTypes.string
    onComplete: React.PropTypes.func
    showMilliseconds: React.PropTypes.bool

  getDefaultProps: ->
    seconds: 60
    size: 300
    color: '#000'
    alpha: 1
    timeFormat: 'hms'
    fontSize: 'auto'
    font: 'Arial'
    showMilliseconds: true

  componentWillReceiveProps: (props) ->
    @_seconds = props.seconds
    @_setupTimer()

  componentDidMount: ->
    @_seconds = @props.seconds
    @_setupTimer()

  componentWillUnmount: ->
    @_cancelTimer()

  _setupTimer: ->
    @_setScale()
    @_setupCanvas()
    @_drawTimer()
    @_startTimer()

  _updateCanvas: ->
    @_clearTimer()
    @_drawTimer()

  _setScale: ->
    @_radius      = @props.size / 2
    @_fraction    = 2 / @_seconds
    @_tickPeriod  = @_calculateTick()
    @_innerRadius =
      if @props.weight
        @_radius - @props.weight
      else
        @_radius / 1.8

  _calculateTick: ->
    # Tick period (milleseconds) needs to be fast for smaller time periods and slower
    # for longer ones. This provides smoother rendering. It should never exceed 1 second.
    tickScale = 1.8
    tick = @_seconds * tickScale
    if tick > 1000 then 1000 else tick

  _setupCanvas: ->
    @_canvas  = @refs.canvas
    @_context = @_canvas.getContext '2d'
    @_context.textAlign = 'center'
    @_context.textBaseline = 'middle'

  _startTimer: ->
    # Give it a moment to collect it's thoughts for smoother render
    @_timeoutIds.push(setTimeout ( => @_tick() ), 200)

  _cancelTimer: ->
    for timeout in @_timeoutIds
      clearTimeout timeout

  _tick: ->
    start = Date.now()
    @_timeoutIds.push(setTimeout ( =>
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
    @_context.arc @_radius, @_radius,      @_radius,           0, Math.PI * 2, false
    @_context.arc @_radius, @_radius, @_innerRadius, Math.PI * 2,           0, true
    @_context.fill()

  _formattedTime: ->
    decimals = (@_seconds <= 9.9 && @props.showMilliseconds) ? 1 : 0

    if @props.timeFormat == 'hms'
      hours   = parseInt( @_seconds / 3600 ) % 24
      minutes = parseInt( @_seconds / 60 ) % 60
      seconds = (@_seconds % 60).toFixed(decimals)

      hoursStr = "#{hours}"
      minutesStr = "#{minutes}"
      secondsStr = "#{seconds}"

      hoursStr   = "0#{hours}" if hours < 10
      minutesStr = "0#{minutes}" if minutes < 10 && hours >= 1
      secondsStr = "0#{seconds}" if seconds < 10 && (minutes >= 1 || hours >= 1)

      timeParts = []
      timeParts.push hoursStr if hours > 0
      timeParts.push minutesStr if minutes > 0 || hours > 0
      timeParts.push secondsStr

      timeParts.join ':'
    else
      return @_seconds.toFixed(decimals)

  _fontSize: (timeString) ->
    if @props.fontSize == 'auto'
      scale = switch timeString.length
        when 8 then 4 # hh:mm:ss
        when 5 then 3 # mm:ss
        else 2        # ss or ss.s
      size = @_radius / scale
      "#{size}px"
    else
      @props.fontSize

  _drawTimer: ->
    percent = @_fraction * @_seconds + 1.5
    formattedTime = @_formattedTime()
    @_context.globalAlpha = @props.alpha
    @_context.fillStyle = @props.color
    @_context.font = "bold #{@_fontSize(formattedTime)} #{@props.font}"
    @_context.fillText formattedTime, @_radius, @_radius
    @_context.beginPath()
    @_context.arc @_radius, @_radius,      @_radius,     Math.PI * 1.5, Math.PI * percent, false
    @_context.arc @_radius, @_radius, @_innerRadius, Math.PI * percent,     Math.PI * 1.5, true
    @_context.fill()

  render: ->
    <canvas ref='canvas' className="react-countdown-clock" width={@props.size} height={@props.size}></canvas>
