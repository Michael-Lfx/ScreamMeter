//
//  IADBannerView.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 3/11/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "IADBannerView.h"

@implementation IADBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
