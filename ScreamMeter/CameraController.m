//
//  CameraController.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/17/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "CameraController.h"
#import "PBJVision.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <GLKit/GLKit.h>
#import "PBJVideoPlayerController.h"

@interface CameraController ()<PBJVisionDelegate,PBJVideoPlayerControllerDelegate>
{
    ALAssetsLibrary *_assetLibrary;
    BOOL _isRecording;
    
    __block NSDictionary *_currentVideo;
    AVCaptureVideoPreviewLayer *_previewLayer;
    UIView *_previewView;

    PBJVideoPlayerController *_videoPlayerController;
    UIActivityIndicatorView *_spinner;
}

@end
@implementation CameraController

+ (id)sharedManager {
    static CameraController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)showSpinner{
    _spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    _spinner.color = [UIColor blueColor];
    [_spinner startAnimating];
    [_parentViewController.view addSubview:_spinner];
    
}

-(void)removeSpinner{
    [_spinner removeFromSuperview];
}

- (id)init
{
    self = [super init];
    if (self) {
       // _parentViewController=parentVC;
        
        _assetLibrary = [[ALAssetsLibrary alloc] init];
        _videoPlayerController = [[PBJVideoPlayerController alloc] init];
        _videoPlayerController.delegate = self;
       // [[PBJVision sharedInstance] setPresentationFrame:_parentViewController.view.frame];
        
        /*
        // preview and AV layer
        _previewView = [[UIView alloc] initWithFrame:CGRectZero];
        _previewView.backgroundColor = [UIColor blackColor];
        CGRect previewFrame = CGRectMake(0, 60.0f, CGRectGetWidth(_parentViewController.view.frame), CGRectGetWidth(_parentViewController.view.frame));
        _previewView.frame = previewFrame;
        _previewLayer = [[PBJVision sharedInstance] previewLayer];
        _previewLayer.frame = _previewView.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_previewView.layer addSublayer:_previewLayer];
        
        [[PBJVision sharedInstance] setPresentationFrame:_previewView.frame];
        [_parentViewController.view addSubview:_previewView];
        */
        [self resetCapture];
        
    }
    return self;
}
-(void)addPreviewLayerOnView:(UIView*)mainView {
    // preview and AV layer
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 60.0f, 100, 100);
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    [[PBJVision sharedInstance] setPresentationFrame:_previewView.frame];
    [mainView addSubview:_previewView];
    
}

-(NSString*)currentVideoPath{
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    return videoPath;
}


- (void)resetCapture
{
    
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    
    //if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
    //    [vision setCameraDevice:PBJCameraDeviceBack];
  //  } else {
        [vision setCameraDevice:PBJCameraDeviceFront];
    //}
    
    [vision setCameraMode:PBJCameraModeVideo];
    [vision setCameraOrientation:PBJCameraOrientationPortrait];
    [vision setFocusMode:PBJFocusModeContinuousAutoFocus];
    [vision setOutputFormat:PBJOutputFormatSquare];
    [vision setVideoRenderingEnabled:YES];

}

-(void)startCurrentVideoPreview{
    [[PBJVision sharedInstance] startPreview];
}

-(void)stopCurrentPreview{
     [[PBJVision sharedInstance] stopPreview];
}

-(void)startCurrentVideoCapture{

    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[PBJVision sharedInstance] startVideoCapture];
}

- (void)pauseCapture{
    [[PBJVision sharedInstance] pauseVideoCapture];

}
-(void)resumeCapture{
    [[PBJVision sharedInstance] resumeVideoCapture];
}

- (void)endCapture{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
}

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    _isRecording = YES;
}


- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    _isRecording = NO;
    
    if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    NSLog(@"Captured Video seconds %f",[[PBJVision sharedInstance]capturedVideoSeconds]);
    NSLog(@"Captured Audio seconds %f",[[PBJVision sharedInstance]capturedAudioSeconds]);

    _currentVideo = videoDict;
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    
    /*
    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Saved!" message: @"Saved to the camera roll."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }];
    */
}

-(void)playButton:(id)sender{
    [_videoPlayerController playFromBeginning];
}

-(void)watchCurrentVideoForParentViewController:(UIViewController*)parentViewController{
    // setup media
    _videoPlayerController.videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    
    // present
    _videoPlayerController.view.frame = parentViewController.view.bounds;
    
    [parentViewController.navigationController pushViewController:_videoPlayerController animated:YES];
    [_videoPlayerController.navigationController setNavigationBarHidden:NO];
    parentViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
   /*
    [parentViewController addChildViewController:_videoPlayerController];
    [parentViewController.view addSubview:_videoPlayerController.view];
    [parentViewController didMoveToParentViewController:parentViewController];
    */
    
}

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer{
    /*
    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
    [videoPlayer.view addSubview:playButton];
    [playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchDown];
    */
    _videoPlayerController.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [_videoPlayerController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer{
    
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer{
    
}
- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer{
    [_videoPlayerController.navigationController popViewControllerAnimated:YES];
    /*
    [videoPlayer didMoveToParentViewController:nil];
    [videoPlayer.view removeFromSuperview];
    [videoPlayer removeFromParentViewController];
    */
}
- (void)visionSessionDidStartPreview:(PBJVision *)vision{
   // [self showSpinner];
}
- (void)visionSessionDidStopPreview:(PBJVision *)vision{
    //[self removeSpinner];
}


- (void)visionSessionDidStart:(PBJVision *)vision{
    NSLog(@"Session did start");
}
- (void)visionSessionDidStop:(PBJVision *)vision{
    NSLog(@"Session did stop");
}


//Average and peak power

-(void)audioPeakPower:(Float32)peakPower andAudioAveragePower:(Float32)averagePower{
    [_parentViewController audioPeakPower:peakPower andAudioAveragePower:averagePower];
}

@end
