# Jogging App

This is a demo app created for showcasing purposes only.

It's a very basic jog logging iOS application that stores user's jogs in the cloud, and provides some basic filtering and reporting functionalities.


## API

The app is using [Parse](https://www.parse.com) as the BaaS provider right now, but the plan is to build a custom more-RESTful API in the near future, to show backend development skills.


## Build

The project uses [CocoaPods](http://cocoapods.org) for managing dependencies, and builds using Xcode 6.1 and LLVM 6.0.


## iOS versions and devices

The app runs on iOS 8+, and it's optimized for iPhone and iPod touch devices with any screen size by using [autolayout](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Introduction/Introduction.html).


## Tests

Tests are implemented using the default XCTest framework and run from Xcode, more information about testing with Xcode can be found [here](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/testing_with_xcode/Introduction/Introduction.html#//apple_ref/doc/uid/TP40014132-CH1-SW1).


## Improvements

There are several improvements for this app in the readmap:

### Offline mode

The app doesn’t have any local storage yet, so it works in online mode only for now.
In a real world project, offline mode would be a very useful feature for this kind of app, and implementation is pretty straightforward using [CoreData](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html).

### Auth

As an user of a real world app, I love being able to login with services like Facebook or Twitter. I'll also add email validation and password recovery features.

### Analytics

In a real world project I would add analysis from the first beta build, by using some external service like [Google Analytics](https://developers.google.com/analytics/devguides/collection/ios/v3/) or [Flurry](http://www.flurry.com/solutions/analytics).


### Location Services

It’d be great to track actual jogs using and display them by using  [CoreLocation and MapKit](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009497-CH1-SW1).

### Security

The API now uses token based authentication, ACL authorisation and SSL. Security is reasonable, but in a real world project I’ll probably invest more time on it and do more testing.

### Scalability

The API should scale pretty well right now as it’s using [Parse](https://www.parse.com), but in a real world project I’ll probably make some tests and see if it can deal with the expected usage scenario, and probably build a custom RESTful API from the ground up.

### Beta build distribution

Normally, I would setup beta build distribution from the first sprint and start delivering as soon as possible, probably using [TestFlight](https://developer.apple.com/app-store/testflight/).

### Documentation

The app code, and most importantly the API interface should be really well documented on a real project.

### Localisation

[Internationalization and Localization](https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/Introduction/Introduction.html) is really important for a real world app, even if it doesn’t support multiple languages in the first releases, but the plumbing should be in place from the beginning of the project.

### Accessibility

[Accessibility](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/iPhoneAccessibility/Introduction/Introduction.html) is one of the greatest things about iOS, and yet it’s overlooked by many apps.

### UI/UX design

Default iOS controls are great, but an app with good graphics and [animations](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html) truly stands out from the crowd.

### Profiling to improve battery usage and responsiveness

Making the most of the available resources should always be a goal in any real-world app, so [profiling](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/Introduction/Introduction.html) to find performance bottlenecks, battery draining spots, and wasted memory is always a good practice.

### Crashlogs

Crash logs should be properly stored to be useful to the developer (easily dSYMd, with timestamp and other relevant information), probably using some external service like [Crashlytics](https://try.crashlytics.com).

### Logging

Logging should be handled using a good extensible framework like [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack), to easily manage different log levels and log destinations (like a remote server for errors).


### Custom RESTful API

Having a custom RESTful API would be great for showing backend development skills.
