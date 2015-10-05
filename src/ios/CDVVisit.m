/********* CDVVisit.m Cordova Plugin Implementation *******/

#import "CDVVisit.h"
#import <Cordova/CDV.h>

#import <CoreLocation/CoreLocation.h>

@interface CDVVisit () <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager *manager;

@end

@implementation CDVVisit

- (void)pluginInitialize {
  NSLog(@"- CDVVisit pluginInitialize");
  _manager = [[CLLocationManager alloc] init];
  self.manager.delegate = self;
}

- (void)startMonitoring:(CDVInvokedUrlCommand*)command {
  NSLog(@"- CDVVisit startMonitoring");
  self.callbackId = command.callbackId;
  [self.manager requestAlwaysAuthorization];
}

#pragma mark - CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  NSLog(@"- CDVVisit didChangeAuthorizationStatus");
  if (status == kCLAuthorizationStatusNotDetermined) {
    // let the app continue to try authorizing
    [manager requestAlwaysAuthorization];
  }
  else if (status == kCLAuthorizationStatusAuthorizedAlways) {
    [manager startMonitoringVisits];
  }
  else {
    if (self.callbackId) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
  }
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
  NSLog(@"- CDVVisit didVisit %@", visit);
  NSMutableDictionary *visitData = [NSMutableDictionary dictionaryWithCapacity:4];

  // if departure date is valid it means we're done with this visit.
  if (![visit.departureDate isEqualToDate:NSDate.distantFuture]) {
    [visitData setValue:[NSNumber numberWithInt:[visit.departureDate timeIntervalSince1970]] forKey:@"departureDate"];
  }

  // if we have no arrival timestamp use the current timestamp instead
  if([visit.arrivalDate isEqualToDate:NSDate.distantPast]) {
    [visitData setValue:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] forKey:@"arrivalDate"];
  }
  else {
    [visitData setValue:[NSNumber numberWithInt:[visit.arrivalDate timeIntervalSince1970]] forKey:@"arrivalDate"];
  }
  [visitData setValue:[NSNumber numberWithFloat:visit.coordinate.latitude] forKey:@"latitude"];
  [visitData setValue:[NSNumber numberWithFloat:visit.coordinate.longitude] forKey:@"longitude"];

  NSDictionary *visitDict = [visitData copy];

  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:visitDict];
  [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

@end
