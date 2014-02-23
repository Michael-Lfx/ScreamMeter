//
//  ScoreDataModel.m
//  FlappyCock
//
//  Created by Amol Chaudhari on 2/11/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "ScoreDataModel.h"

@interface ScoreDataModel ()

@property(nonatomic,assign)NSInteger highScore;
@property(nonatomic,assign)int currentScore;

@end
@implementation ScoreDataModel


- (id)init
{
    self = [super init];
    if (self) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _highScore = [prefs integerForKey:@"HIGH_SCORE"];
        _currentScore=0;
    }
    return self;
}

-(NSString *)currentScoreString{
    NSString *currentScoreString = [NSString stringWithFormat:@"%d",_currentScore];
    return currentScoreString;
}

-(NSString *)highScoreString{
    NSString *highScoreString = [NSString stringWithFormat:@"%ld",(long)_highScore];
    return highScoreString;
}

-(void)addOneToScore{
    _currentScore=_currentScore+1;
    
    if (_highScore<_currentScore) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:_currentScore forKey:@"HIGH_SCORE"];
        [prefs synchronize];
        _highScore=_currentScore;
    }
}


@end
