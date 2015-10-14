# cordova-plugin-visit
CLVisit plugin for Cordova

This plugin implements Apple's Core Location Visit functionality. It will have CLLocationManager Initiate Visit Event Updates and then handle the event didVisit.

*Functionality is limited to iOS only!*

The CLVisit data will be passed back to the cordova app as a javascript object with attributes like the following example:


```
{
	"arrivalDate": 1444766800,
	"departureDate": 1444781724,
	"latitude": 37.76315,
	"longitude": -122.4139
}
```

Arrival and Departure dates will both be provided as UTC based unix timestamps.
Latitude and Longitude are provided as floating points numbers.

There are two types of visit events: arrival and departure.
If departureDate is undefined, it is an arrival visit event.
If the arrival date is indeterminable it is overridden to the timestamp of the CLVisit event arrival. This is probably not accurate but as close of a guess as one can make.

# Installation
`cordova plugin add https://github.com/oursiberia/cordova-plugin-visit.git`

# Quickstart
```
if( window.plugins.visit )
{
	// use startMonitoring and provide success, failure callbacks
	window.plugins.visit.startMonitoring( function( visit ) // success!
	{
		console.log( 'Visit: ', visit );

		if( visit.departureDate ) // we know this is a departure visit
		{

		}
		else // this is an arrival visit
		{

		}
	}, function(  ) // error!
	{

	} );
}
```

# Reference
1. https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/#//apple_ref/doc/uid/TP40007125-CH3-SW81
1. https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/CLLocationManagerDelegate/locationManager:didVisit:
1. https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLVisit_class/index.html#//apple_ref/swift/cl/c:objc(cs)CLVisit

# License
http://creativecommons.org/licenses/by-sa/4.0/
