/********* CDVVisit.m Cordova Plugin Implementation *******/

#import "CDVVisit.h"
#import <Cordova/CDV.h>
#import "LocationManager.h"

@import CoreLocation;

@interface CDVVisit () <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager *manager;

@end

@implementation CDVVisit

- (id)init {
  self = [super init];
  if (!self) return nil;

  _manager = [[CLLocationManager alloc] init];
  self.manager.delegate = self;

  return self;
}

- (void)startMonitoring:(CDVInvokedUrlCommand*)command {
  self.callbackId = command.callbackId;
  [self.manager requestAlwaysAuthorization];
}

#pragma mark - CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusAuthorizedAlways) {
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
  NSMutableDictionary *visitData = [NSMutableDictionary dictionaryWithDictionary:@{
                                   // @"name": [NSUserDefaults.standardUserDefaults objectForKey:@"name"],
                                    @"latitude": @(visit.coordinate.latitude),
                                    @"longitude": @(visit.coordinate.longitude),
                                    @"arrivalDate": visit.arrivalDate
                                    }];

  if (![visit.departureDate isEqualToDate:NSDate.distantFuture]) {
    visitData[@"departureDate"] = visit.departureDate;
  }

  NSDictionary *visitDict = [visitData copy];

  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:visitDict];
  [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

@end
