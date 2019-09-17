# Changelog

## 2.7.0
  * Update npm dependencies

## 2.6.0
  * Update npm dependencies

## 2.5.0
  * Update npm dependencies

## 2.4.0 Mat 7, 2018
  * Fix code not transpilling to ES5

## 2.3.0
  * Fix 60 seconds showing at minute transition #38 - Thanks @7022Andre
  * Fix Uncaught TypeError: Cannot read property 'width' of undefined at Object._clearTimer #34
  * Only show full start time when starting paused

## 2.2.0 - Mar 6, 2018
  * Build with Webpack 4
  * Update npm dependencies
  * Fix issue with background being re-rendered over itself. Thanks @mbstrauss

## 2.1.0 - Mar 6, 2018
	* Reset timer if seconds change. Thanks @mmajis
	* Makes div the same size as the countdown clock. Thanks @Miniland1333
	* Fix old props being assigned rather than new. Thanks @zaidchauhan
	* Scale canvas for high DPI devices. Thanks @gravitypersists 

## 2.0.0 - Jul 19, 2017
 * Fix deprecation warnings in React 15.6.0. Thanks @AaronKalair
 * Fix Fixes missing minute components when hour is > 0. Thanks @KTachyon

## 1.1.0 - Dec 30, 2016
  * Move to semantic versioning
  * Reduce the ammount of canvas drawing
  * Allow colour to be updated without resetting the timer
  * Allow timer to be paused

## 1.0.9 - Aug 31, 2016
  * Fix invalid react proptype for showMilliseconds. Thanks @sabazusi.

## 1.0.8 - Aug 8, 2016

  * Updated React version in peerDependencies
  * Added new props for fontSize, font, timeFormat and showMilliseconds
  * Added ability to render minutes and hours
  * Fixed long countdowns having a tick period longer than 1 second

## 1.0.7 - Aug 7, 2016

  * Weight of circle can now be configured. Thanks @rutan.

## 1.0.6 - Feb 18, 2016

  * Added licence

## 1.0.5 - Dec 22, 2015

  * Removed React into peerDependencies
  * Removed Shrinkwrap

## 1.0.5 - Dec 21, 2015

  * Removed ReactDOM dependency

## 1.0.4 - Dec 20, 2015

  * Upgraded React (0.14.3) and dev dependencies
  * Clear timeouts on componentWillUnmount

## 1.0.3 - May 25, 2015

  * General fixes from @dvilchez
  * Added npm shrinkwrap
  * Fixed issue where seconds would never reach zero.

## 1.0.2 - Jan 18, 2015

  * Updated README with more details

## 1.0.1 - Jan 17, 2015

  * Added README

## 1.0.0 - Jan 17, 2015

  * Counter with demo
