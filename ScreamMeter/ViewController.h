//
//  ViewController.h
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/14/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSUInteger, ScreamingGameplayState){
    ScreamingNotStartedState,
    ScreamingStartedState,
    ScreamingStoppedState
};

@interface ViewController : UIViewController

-(void)audioPeakPower:(Float32)peakPower andAudioAveragePower:(Float32)averagePower;

@end
