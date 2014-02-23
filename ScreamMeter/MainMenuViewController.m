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

-(IBAction)openMoreGames:(id)sender;

-(IBAction)rateUs:(id)sender;

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


-(IBAction)openMoreGames:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/artist/appagogo/id552771306"]];
}


//https://itunes.apple.com/us/app/screammeter/id827482116?ls=1&mt=8
-(IBAction)rateUs:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/screammeter/id827482116?ls=1&mt=8"]];

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
