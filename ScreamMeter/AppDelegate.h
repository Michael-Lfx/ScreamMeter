//
//  AppDelegate.h
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/14/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
