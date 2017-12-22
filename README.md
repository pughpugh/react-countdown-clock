# React Countdown Clock

A HTML 5 canvas countdown clock as a React component.

![Screenshot](http://pughpugh.github.io/react-countdown-clock/animated.gif)

## Demo

[pughpugh.github.io/react-countdown-clock](http://pughpugh.github.io/react-countdown-clock)

## Installation

```
npm install react-countdown-clock
```

## Usage

```javascript
<ReactCountdownClock seconds={60}
                     color="#000"
                     alpha={0.9}
                     size={300}
                     onComplete={myCallback} />
```

## Props

| prop             | type           | default | description                                               |
|------------------|----------------|---------|-----------------------------------------------------------|
| seconds          | integer        | 60      | Seconds to countdown                                      |
| color            | string         | #000    | Colour of counter                                         |
| alpha            | float          | 1.0     | Alpha transparency of counter                             |
| size             | integer        | 300     | Width & height of canvas element                          |
| weight           | integer        |         | Weight of circle, in pixels                               |
| fontSize         | integer/string | auto    | px size of font. `auto` for dynamic sizing.               |
| font             | string         | Arial   | Font of counter                                           |
| timeFormat       | string         | seconds | Counter style; `seconds` or `hms`                         |
| showMilliseconds | boolean        | true    | Show milliseconds for last 10 seconds                     |
| onComplete       | func           |         | Callback when time completes                              |
| paused           | boolean        | false   | Pause countdown of the timer                              |
| pausedText       | string         |         | Text to display when paused, defaults to the current time |

## Bugs & Contributions

Bugs, features and pull requests always welcome.

[github.com/pughpugh/react-countdown-clock/issues](https://github.com/pughpugh/react-countdown-clock/issues)

Also, it's always just nice to hear how people are using it. Feel free to get in touch.

* Email: [hugh@hcgallagher.co.uk](mailto:hugh@hcgallagher.co.uk)
* Web: [www.hughgallagher.co.uk](http://www.hughgallagher.co.uk/)
