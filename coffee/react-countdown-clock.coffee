React  = require 'react'
PropTypes = require 'prop-types'
CreateReactClass = require 'create-react-class'

ReactCountdownClock = CreateReactClass
  _seconds: 0
  _radius: null
  _fraction: null
  _content: null
  _canvas: null
  _timeoutIds: []
  _scale: window.devicePixelRatio || 1

  displayName: 'ReactCountdownClock'

  componentDidUpdate: (prevProps) ->
    if prevProps.seconds != @props.seconds
      @_seconds = @_startSeconds()
      @_stopTimer()
      @_setupTimer()

    if prevProps.color != @props.color
      @_drawBackground()
      @_updateCanvas()

    if prevProps.paused != @props.paused
      @_startTimer() if !@props.paused
      @_pauseTimer() if @props.paused

  componentDidMount: ->
    @_seconds = @_startSeconds()
    @_setupTimer()

  componentWillUnmount: ->
    @_cancelTimer()

  _startSeconds: ->
    # To prevent a brief flash of the start time when not paused
    if @props.paused then @props.seconds else @props.seconds - 0.01

  _setupTimer: ->
    @_setScale()
    @_setupCanvases()
    @_drawBackground()
    @_drawTimer()
    @_startTimer() unless @props.paused

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

  _setupCanvases: ->
    return if @_background && @_timer

    @_background = @refs.background.getContext '2d'
    @_background.scale @_scale, @_scale

    @_timer = @refs.timer.getContext '2d'
    @_timer.textAlign = 'center'
    @_timer.textBaseline = 'middle'
    @_timer.scale @_scale, @_scale

    if @props.onClick?
      @refs.component.addEventListener 'click', @props.onClick

  _startTimer: ->
    # Give it a moment to collect it's thoughts for smoother render
    @_timeoutIds.push(setTimeout( => @_tick() ), 200)

  _pauseTimer: ->
    @_stopTimer()
    @_updateCanvas()

  _stopTimer: ->
    for timeout in @_timeoutIds
      clearTimeout timeout

  _cancelTimer: ->
    @_stopTimer()

    if @props.onClick?
      @refs.component.removeEventListener 'click', @props.onClick

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

  _clearBackground: ->
    @_background.clearRect 0, 0, @refs.timer.width, @refs.timer.height

  _clearTimer: ->
    if @refs.timer?
      @_timer.clearRect 0, 0, @refs.timer.width, @refs.timer.height

  _drawBackground: ->
    @_clearBackground()
    @_background.beginPath()
    @_background.globalAlpha = @props.alpha / 3
    @_background.fillStyle = @props.color
    @_background.arc @_radius, @_radius,      @_radius,           0, Math.PI * 2, false
    @_background.arc @_radius, @_radius, @_innerRadius, Math.PI * 2,           0, true
    @_background.closePath()
    @_background.fill()

  _formattedTime: ->
    decimals = (@_seconds < 10 && @props.showMilliseconds) ? 1 : 0

    if @props.timeFormat == 'hms'
      hours   = parseInt( @_seconds / 3600 ) % 24
      minutes = parseInt( @_seconds / 60 ) % 60

      if decimals
        seconds = ((Math.floor(@_seconds * 10) / 10)).toFixed(decimals)
      else
        seconds = Math.floor(@_seconds % 60)

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
      (Math.floor(@_seconds * 10) / 10).toFixed(decimals)

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
    text = if (@props.paused && @props.pausedText?) then @props.pausedText else formattedTime

    # Timer
    @_timer.globalAlpha = @props.alpha
    @_timer.fillStyle = @props.color
    @_timer.font = "bold #{@_fontSize(formattedTime)} #{@props.font}"
    @_timer.fillText text, @_radius, @_radius
    @_timer.beginPath()
    @_timer.arc @_radius, @_radius, @_radius,      Math.PI * 1.5,     Math.PI * percent, false
    @_timer.arc @_radius, @_radius, @_innerRadius, Math.PI * percent, Math.PI * 1.5,     true
    @_timer.closePath()
    @_timer.fill()

  render: ->
    canvasStyle = { position: 'absolute', width: @props.size, height: @props.size }
    canvasProps = { style: canvasStyle, height: @props.size * @_scale, width: @props.size * @_scale }

    <div ref='component' className="react-countdown-clock" style={width: @props.size, height: @props.size}>
      <canvas ref='background' {...canvasProps}></canvas>
      <canvas ref='timer' {...canvasProps}></canvas>
    </div>

ReactCountdownClock.propTypes =
  seconds: PropTypes.number
  size: PropTypes.number
  weight: PropTypes.number
  color: PropTypes.string
  fontSize: PropTypes.string
  font: PropTypes.string
  alpha: PropTypes.number
  timeFormat: PropTypes.string
  onComplete: PropTypes.func
  onClick: PropTypes.func
  showMilliseconds: PropTypes.bool
  paused: PropTypes.bool
  pausedText: PropTypes.string

ReactCountdownClock.defaultProps =
  seconds: 60
  size: 300
  color: '#000'
  alpha: 1
  timeFormat: 'hms'
  fontSize: 'auto'
  font: 'Arial'
  showMilliseconds: true
  paused: false

module.exports = ReactCountdownClock
