# LoggerWrapper

[![CI Status](https://www.bitrise.io/app/d46117a0546c3b90/status.svg?token=l82ufBXVKw111pmLbSAjDg&branch=master)](https://www.bitrise.io/app/d46117a0546c3b90)
[![Version](https://img.shields.io/cocoapods/v/LoggerWrapper.svg?style=flat)](http://cocoapods.org/pods/LoggerWrapper)
[![License](https://img.shields.io/cocoapods/l/LoggerWrapper.svg?style=flat)](http://cocoapods.org/pods/LoggerWrapper)
[![Platform](https://img.shields.io/cocoapods/p/LoggerWrapper.svg?style=flat)](http://cocoapods.org/pods/LoggerWrapper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

None.

## Installation

LoggerWrapper aims to provide a simple wrapper around the various logging library that exists for iOS.

Ideally, this library allows library creators to allow to use logging, without relying on the classic NSLog/print which can't be disabled easily.
If you're a library creator, just reference `LoggerWrapper` as a dependency of it in your Podspec.  
Users of your library may then implement their own logging on top of it (or use one of our subspecs to get it for free), or even just choose to leave it disabled.

LoggerWrapper is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'LoggerWrapper/Swift'
```

The library requires your app to use `use_frameworks!`. If your library/app isn't in Swift (or for an app, if you don't (can't?) want to use `use_frameworks!` in your Podfile), you can restrict to using only the Objective-C version:

```ruby
pod 'LoggerWrapper/ObjC'
```

### With CocoaLumberjack

To install, add the following line instead in your Podfile:

```ruby
pod 'LoggerWrapper/CocoaLumberjack/Swift'
```

(You may also replace Swift for ObjC for the same reasons as above)

This subspec provides a subclass of `STCLogger` called `STCCocoaLumberjackLogger`, which sets up a default configuration for CocoaLumberjack.

#### With PluggableApplicationDelegate

This subspec provide an `ApplicationService` class called `LoggingApplicationService` that automatically set up a CocoaLumberjack File Logger to save the logs to the Device (and allow you to retrieve them), and set `STCLogger.shared` to an instance of `STCCocoaLumberjackLogger` 

To install, add the following line instead in your Podfile:

```ruby
pod 'LoggerWrapper/CocoaLumberjack/PluggableApplicationDelegate'
```

And add an instance of `LoggingApplicationService()` to the list of services you give to the `PluggableApplicationDelegate`.

## Author

Stéphane Copin, stephane.copin@live.fr

## License

LoggerWrapper is available under the MIT license. See the LICENSE file for more info.
