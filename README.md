# React Countdown Clock

A HTML 5 canvas countdown clock as a React component.

![Screenshot](http://pughpugh.github.io/react-countdown-clock/screenshot.png?=0)

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

* `seconds` to count down
* `color` you'd like it to be as a hex/css colour code
* `alpha` transparency for component
* `size` for height and width of canvas element, in pixels.
* `weight` for weight of circle, in pixels.
* `onComplete` callback when timer completes

## Bugs & Contributions

Bugs, features and pull requests always welcome.

[github.com/pughpugh/react-countdown-clock/issues](https://github.com/pughpugh/react-countdown-clock/issues)

Also, it's always just nice to hear how people are using it. Feel free to get in touch.

* Email: [hugh@hcgallagher.co.uk](mailto:hugh@hcgallagher.co.uk)
* Web: [www.hughgallagher.co.uk](http://www.hughgallagher.co.uk/)
