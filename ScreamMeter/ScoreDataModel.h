//
//  ScoreDataModel.h
//  FlappyCock
//
//  Created by Amol Chaudhari on 2/11/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreDataModel : NSObject

@property(nonatomic,readonly)NSInteger highScore;
@property(nonatomic,readonly)int currentScore;
@property(nonatomic,readonly)NSString *currentScoreString;
@property(nonatomic,readonly)NSString *highScoreString;

-(void)addOneToScore;
@end
