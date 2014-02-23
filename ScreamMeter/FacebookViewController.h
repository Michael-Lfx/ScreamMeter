//
//  FacebookViewController.h
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/18/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController : UIViewController
@property (nonatomic, copy) void (^executeAfterLogin)();

@end
