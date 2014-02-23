//
//  MMediaInterstitialAdViewController.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/23/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "MMediaInterstitialAdViewController.h"
#import "MMInterstitial.h"
#import "AppDelegate.h"
#import "MMAdView.h"


@interface MMediaInterstitialAdViewController ()

@end

@implementation MMediaInterstitialAdViewController

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
    [self.navigationController setNavigationBarHidden:YES];
   // [self displayMMediaInterstatialAds];
    [self displayMMediaRectangleAd];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"MainMenuViewController" sender:self];
    });
    
}

-(void)displayMMediaRectangleAd{
    
    //Location Object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //MMRequest Object
    MMRequest *request = [MMRequest requestWithLocation:appDelegate.locationManager.location];
    
    // Replace Your_APID with the APID provided to you by Millennial Media
    MMAdView *banner = [[MMAdView alloc] initWithFrame:CGRectMake(10,20,300,250) apid:@"152730"
                                    rootViewController:self];
    [self.view addSubview:banner];
    [banner getAdWithRequest:request onCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"RECTANGLE AD REQUEST SUCCEEDED");
        }
        else {
            NSLog(@"RECTANGLE AD REQUEST FAILED WITH ERROR: %@", error);
        }
    }];
    
}

-(void)displayMMediaInterstatialAds{
    
    //Location Object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if ([MMInterstitial isAdAvailableForApid:@"152729"]) {
        [MMInterstitial displayForApid:@"152729"
                    fromViewController:self
                       withOrientation:0
                          onCompletion:nil];
    }
    else {
        //MMRequest Object
        MMRequest *request = [MMRequest requestWithLocation:appDelegate.locationManager.location];
        
        
        [MMInterstitial fetchWithRequest:request
                                    apid:@"152729"
                            onCompletion:^(BOOL success, NSError *error) {
                                if (success) {
                                    [MMInterstitial displayForApid:@"152729"
                                                fromViewController:self
                                                   withOrientation:0
                                                      onCompletion:nil];
                                }
                            }];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
