//
//  CameraController.h
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/17/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
@interface CameraController : NSObject
{
    
}

@property(nonatomic,weak)ViewController *parentViewController;


//- (id)initWithParentViewController:(UIViewController*)parentVC;
+ (id)sharedManager;
- (void)resetCapture;
-(NSString*)currentVideoPath;

-(void)watchCurrentVideoForParentViewController:(UIViewController*)parentViewController;

-(void)startCurrentVideoCapture;
- (void)endCapture;
-(void)startCurrentVideoPreview;
-(void)stopCurrentPreview;
-(void)addPreviewLayerOnView:(UIView*)mainView;
@end
