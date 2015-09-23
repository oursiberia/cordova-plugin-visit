#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVVisit : CDVPlugin

@property (strong, nonatomic) NSString* callbackId;

- (void)startMonitoring:(CDVInvokedUrlCommand*)command;

@end
