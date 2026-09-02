import React, { useEffect, useRef, useCallback } from 'react';
import PropTypes from 'prop-types';

const ReactCountdownClock = ({
  seconds = 60,
  size = 300,
  weight,
  color = '#000',
  fontSize = 'auto',
  font = 'Arial',
  alpha = 1,
  timeFormat = 'hms',
  onComplete,
  onClick,
  showMilliseconds = true,
  paused = false,
  pausedText
}) => {
  const backgroundCanvasRef = useRef(null);
  const timerCanvasRef = useRef(null);
  const containerRef = useRef(null);
  
  const timerIdRef = useRef(null);
  const secondsLeftRef = useRef(paused ? seconds : seconds - 0.01);
  const prevPausedRef = useRef(paused);
  const prevSecondsRef = useRef(seconds);
  const prevColorRef = useRef(color);

  const scale = typeof window !== 'undefined' ? (window.devicePixelRatio || 1) : 1;
  const radius = size / 2;
  const fraction = 2 / seconds;
  const innerRadius = weight ? radius - weight : radius / 1.8;

  const getTickPeriod = useCallback((secs) => {
    const tickScale = 1.8;
    const tick = secs * tickScale;
    return tick > 1000 ? 1000 : tick;
  }, []);

  const formattedTime = useCallback((secs) => {
    const decimals = (secs < 10 && showMilliseconds) ? 1 : 0;
    
    if (timeFormat === 'hms') {
      const hours = parseInt(secs / 3600) % 24;
      const minutes = parseInt(secs / 60) % 60;
      
      let s;
      if (decimals) {
        s = (Math.floor(secs * 10) / 10).toFixed(decimals);
      } else {
        s = Math.floor(secs % 60);
      }
      
      let hoursStr = `${hours}`;
      let minutesStr = `${minutes}`;
      let secondsStr = `${s}`;
      
      if (hours < 10) hoursStr = `0${hours}`;
      if (minutes < 10 && hours >= 1) minutesStr = `0${minutes}`;
      if (s < 10 && (minutes >= 1 || hours >= 1)) secondsStr = `0${s}`;
      
      const timeParts = [];
      if (hours > 0) timeParts.push(hoursStr);
      if (minutes > 0 || hours > 0) timeParts.push(minutesStr);
      timeParts.push(secondsStr);
      
      return timeParts.join(':');
    } else {
      return (Math.floor(secs * 10) / 10).toFixed(decimals);
    }
  }, [timeFormat, showMilliseconds]);

  const getFontSize = useCallback((timeString) => {
    if (fontSize === 'auto') {
      let scaleSize;
      switch (timeString.length) {
        case 8: scaleSize = 4; break; // hh:mm:ss
        case 5: scaleSize = 3; break; // mm:ss
        default: scaleSize = 2; break; // ss or ss.s
      }
      const sizePx = radius / scaleSize;
      return `${sizePx}px`;
    }
    return fontSize;
  }, [fontSize, radius]);

  const clearTimer = useCallback(() => {
    const canvas = timerCanvasRef.current;
    if (canvas) {
      const ctx = canvas.getContext('2d');
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
  }, []);

  const clearBackground = useCallback(() => {
    const canvas = backgroundCanvasRef.current;
    if (canvas) {
      const ctx = canvas.getContext('2d');
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
  }, []);

  const drawBackground = useCallback(() => {
    clearBackground();
    const canvas = backgroundCanvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    
    ctx.save();
    ctx.scale(scale, scale);
    ctx.beginPath();
    ctx.globalAlpha = alpha / 3;
    ctx.fillStyle = color;
    ctx.arc(radius, radius, radius, 0, Math.PI * 2, false);
    ctx.arc(radius, radius, innerRadius, Math.PI * 2, 0, true);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }, [clearBackground, scale, alpha, color, radius, innerRadius]);

  const drawTimer = useCallback((secs) => {
    const percent = fraction * secs + 1.5;
    const fTime = formattedTime(secs);
    const text = (paused && pausedText != null) ? pausedText : fTime;

    const canvas = timerCanvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    
    ctx.save();
    ctx.scale(scale, scale);
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.globalAlpha = alpha;
    ctx.fillStyle = color;
    ctx.font = `bold ${getFontSize(fTime)} ${font}`;
    ctx.fillText(text, radius, radius);
    ctx.beginPath();
    ctx.arc(radius, radius, radius, Math.PI * 1.5, Math.PI * percent, false);
    ctx.arc(radius, radius, innerRadius, Math.PI * percent, Math.PI * 1.5, true);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }, [fraction, formattedTime, paused, pausedText, scale, alpha, color, getFontSize, font, radius, innerRadius]);

  const updateCanvas = useCallback((secs) => {
    clearTimer();
    drawTimer(secs);
  }, [clearTimer, drawTimer]);

  const stopTimer = useCallback(() => {
    if (timerIdRef.current) {
      clearTimeout(timerIdRef.current);
      timerIdRef.current = null;
    }
  }, []);

  const tick = useCallback(() => {
    const start = Date.now();
    timerIdRef.current = setTimeout(() => {
      const duration = (Date.now() - start) / 1000;
      secondsLeftRef.current -= duration;

      if (secondsLeftRef.current <= 0) {
        secondsLeftRef.current = 0;
        if (onComplete) {
          onComplete();
        }
        clearTimer();
      } else {
        updateCanvas(secondsLeftRef.current);
        tick();
      }
    }, getTickPeriod(secondsLeftRef.current));
  }, [getTickPeriod, onComplete, clearTimer, updateCanvas]);

  const startTimer = useCallback(() => {
    // Give it a moment to collect its thoughts for smoother render (matches original behavior)
    timerIdRef.current = setTimeout(() => tick(), 200);
  }, [tick]);

  // Initial setup and prop changes
  useEffect(() => {
    let shouldStart = false;

    // Check if seconds changed
    if (prevSecondsRef.current !== seconds) {
      secondsLeftRef.current = paused ? seconds : seconds - 0.01;
      stopTimer();
      drawBackground();
      drawTimer(secondsLeftRef.current);
      if (!paused) {
        shouldStart = true;
      }
    } 
    // Check if color changed
    else if (prevColorRef.current !== color) {
      drawBackground();
      updateCanvas(secondsLeftRef.current);
    }
    // Check if paused changed
    else if (prevPausedRef.current !== paused) {
      if (!paused) {
        shouldStart = true;
      } else {
        stopTimer();
        updateCanvas(secondsLeftRef.current);
      }
    }

    if (shouldStart) {
      startTimer();
    }

    prevSecondsRef.current = seconds;
    prevPausedRef.current = paused;
    prevColorRef.current = color;
  }, [seconds, paused, color, stopTimer, drawBackground, drawTimer, updateCanvas, startTimer]);

  // ComponentDidMount logic
  useEffect(() => {
    drawBackground();
    drawTimer(secondsLeftRef.current);
    if (!paused) {
      startTimer();
    }
    return () => {
      stopTimer();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []); // Only run once on mount

  const canvasStyle = { position: 'absolute', width: size, height: size };
  const canvasProps = { style: canvasStyle, height: size * scale, width: size * scale };

  return (
    <div ref={containerRef} className="react-countdown-clock" style={{ width: size, height: size }} onClick={onClick}>
      <canvas ref={backgroundCanvasRef} {...canvasProps} />
      <canvas ref={timerCanvasRef} {...canvasProps} />
    </div>
  );
};

ReactCountdownClock.propTypes = {
  seconds: PropTypes.number,
  size: PropTypes.number,
  weight: PropTypes.number,
  color: PropTypes.string,
  fontSize: PropTypes.string,
  font: PropTypes.string,
  alpha: PropTypes.number,
  timeFormat: PropTypes.string,
  onComplete: PropTypes.func,
  onClick: PropTypes.func,
  showMilliseconds: PropTypes.bool,
  paused: PropTypes.bool,
  pausedText: PropTypes.string,
};

export default ReactCountdownClock;
