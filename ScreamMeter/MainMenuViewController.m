//
//  MainMenuViewController.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/15/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CameraController.h"


@interface MainMenuViewController ()


@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[CameraController sharedManager] startCurrentVideoPreview];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
