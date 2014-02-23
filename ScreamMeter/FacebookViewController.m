//
//  FacebookViewController.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/18/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "FacebookViewController.h"
#import "FacebookController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController ()

-(IBAction)loginFacebook:(id)sender;

@end

@implementation FacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)loginFacebook:(id)sender{
    [[FacebookController sharedInstance]loginUserWithBlock:^{
        UIButton *sender = (UIButton*)sender;
        sender.titleLabel.text=@"You are now logged in";
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
