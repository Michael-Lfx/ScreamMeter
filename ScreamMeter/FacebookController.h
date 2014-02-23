//
//  FacebookController.h
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/17/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookController : NSObject<UIApplicationDelegate>
@property(nonatomic,weak)UIViewController *parentViewController;

+ (id)sharedInstance;

- (void)loginUser;
-(void)publishVideoWithUrl:(NSString*)urlString;
- (void)loginUserWithBlock:(void (^)())blockName;
-(BOOL)isUserLoggedInFacebook;

-(void)loginUsingAccountStoreWithBlock:(void (^)())block;
-(void)getPublishRights:(void (^)())block;
@end
