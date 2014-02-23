//
//  ViewController.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/14/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScoreDataModel.h"
#import "CameraController.h"
#import "FacebookController.h"

#import "FacebookViewController.h"


@interface ViewController (){
    AVCaptureDevice *_flashLight;
    AVAudioRecorder *_recorder;
	NSTimer *_levelTimer;
    NSTimer *_checkCountdownTimer;
	double lowPassResults;
    double _peakPowerForChannel;
    
    NSTimeInterval _totalCountdownInterval;
    NSDate* _startDate;
    
    ScoreDataModel *_scoreDataModel;
    CameraController *_cameraController;
}
@property(nonatomic,weak)IBOutlet UILabel *currentScoreLabel;
@property(nonatomic,weak)IBOutlet UILabel *highScoreLabel;
@property(nonatomic,weak)IBOutlet UILabel *bestLabel;
@property(nonatomic,weak)IBOutlet UIButton *restartButton;
@property(nonatomic,weak)IBOutlet UIButton *mainMenuButton;
@property(nonatomic,weak)IBOutlet UIButton *watchVideoButton;
@property(nonatomic,weak)IBOutlet UIButton *facebookShareButton;


-(IBAction)restartGame:(id)sender;
-(IBAction)gotoMainMenu:(id)sender;
-(IBAction)watchVideo:(id)sender;
-(IBAction)shareOnfacebook:(id)sender;


@property(nonatomic,strong)IBOutletCollection(UIImageView)NSArray* redLightsImageViewArray;
@property(nonatomic,strong)IBOutletCollection(UIImageView)NSArray* greenLightsImageViewArray;
@property(nonatomic,strong)IBOutletCollection(UIImageView)NSArray* yellowLightsImageViewArray;


@end

@implementation ViewController

- (void)levelTimerCallback:(NSTimer *)timer {
	[_recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));

	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    
    [self displayAudioMeterCheckForAudioSize:peakPowerForChannel];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                              [NSNumber numberWithFloat:peakPowerForChannel]
                                                         forKey:@"peakPowerForChannel"];
    [self updateGamePlayState:peakPowerForChannel];
   // [[NSNotificationCenter defaultCenter]
    // postNotificationName:@"ChangeFlashLevel"
     //object:self userInfo:userInfo];

//	NSLog(@"PeakPower for channel: %f, Average input: %f Peak input: %f Low pass results: %f",peakPowerForChannel, [_recorder averagePowerForChannel:0], [_recorder peakPowerForChannel:0], lowPassResults);
  //	NSLog(@"PeakPower for channel: %f",lowPassResults);
  
  //  _flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  /*
    if([_flashLight isTorchAvailable] && [_flashLight isTorchModeSupported:AVCaptureTorchModeOn]){
        [_flashLight lockForConfiguration:nil];
        if (peakPowerForChannel==1.0f) {
            [_flashLight setTorchModeOnWithLevel:AVCaptureMaxAvailableTorchLevel error:NULL];
        }else if(peakPowerForChannel<0.3){
            [_flashLight setTorchMode:AVCaptureTorchModeOff];
            if (ScreamingGameplayState == ScreamingStartedState) {
                ScreamingGameplayState=ScreamingStoppedState;
            }
            
        }else{
            float lightValue = peakPowerForChannel - 0.2;
            [_flashLight setTorchModeOnWithLevel:lightValue error:NULL];
            if (ScreamingGameplayState == ScreamingNotStartedState) {
                ScreamingGameplayState = ScreamingStartedState;
            }
        }
        [_flashLight unlockForConfiguration];
    }
    */
    
}

-(void)updateGamePlayState:(double)peakPowerForChannel{

    if (peakPowerForChannel==1.0f) {

        }else if(peakPowerForChannel<0.3){
            if (ScreamingGameplayState == ScreamingStartedState) {
                ScreamingGameplayState=ScreamingStoppedState;
            }
            
        }else{
            float lightValue = peakPowerForChannel - 0.2;
            if (ScreamingGameplayState == ScreamingNotStartedState) {
                ScreamingGameplayState = ScreamingStartedState;
            }
        }
}

-(void)receivedPeakPower:(NSTimer*)timer{
    
       double peakPowerForChannel=_peakPowerForChannel;
    NSLog(@"peakValue = %f",peakPowerForChannel);
    

    [self displayAudioMeterCheckForAudioSize:peakPowerForChannel];
   
    /*
    if([_flashLight isTorchAvailable] && [_flashLight isTorchModeSupported:AVCaptureTorchModeOn]){
        [_flashLight lockForConfiguration:nil];
        if (peakPowerForChannel==1.0f) {
            [_flashLight setTorchModeOnWithLevel:AVCaptureMaxAvailableTorchLevel error:NULL];
        }else if(peakPowerForChannel<0.1){
            [_flashLight setTorchMode:AVCaptureTorchModeOff];
            if (ScreamingGameplayState == ScreamingStartedState) {
                ScreamingGameplayState=ScreamingStoppedState;
            }
            
        }else{
            float lightValue = peakPowerForChannel;
            [_flashLight setTorchModeOnWithLevel:lightValue error:NULL];
            if (ScreamingGameplayState == ScreamingNotStartedState) {
                ScreamingGameplayState = ScreamingStartedState;
            }
        }
        [_flashLight unlockForConfiguration];
    }
    */
}

-(void)displayAudioMeterCheckForAudioSize:(float)audioSignal{
    
    for (UIImageView *redImageView in _redLightsImageViewArray) {
        if (audioSignal > 0.6) {
            UIImage *redImage = [UIImage imageNamed:@"red.jpeg"];
            [redImageView setImage:redImage];
        }else if (audioSignal < 0.6){
            [redImageView setImage:nil];
        }
    }
    
    for (UIImageView *yellowImageView in _yellowLightsImageViewArray) {
        if (audioSignal > 0.3) {
            UIImage *yellowImage = [UIImage imageNamed:@"yellow.jpeg"];
            [yellowImageView setImage:yellowImage];
        }else{
            [yellowImageView setImage:nil];
        }
    }
    
    for (UIImageView *greenImageView in _greenLightsImageViewArray) {
        if (audioSignal > 0.1) {
            UIImage *greenImage = [UIImage imageNamed:@"green.jpeg"];
            [greenImageView setImage:greenImage];
        }else{
            [greenImageView setImage:nil];
        }
    }
    
}

-(void) checkCountdown:(NSTimer*)_timer {
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    
    NSTimeInterval remainingTime = _totalCountdownInterval - elapsedTime;
    /*
     if (remainingTime <= 0.0) {
     [_timer invalidate];
     }
     */
    /* update the interface by converting remainingTime (which is in seconds)
     to seconds, minutes, hours */
    switch (ScreamingGameplayState) {
        case ScreamingStartedState:
            [_scoreDataModel addOneToScore];
            _currentScoreLabel.text = _scoreDataModel.currentScoreString;
            break;
        case ScreamingStoppedState:
            [self stopSessions];
            break;
        default:
            break;
    }
    
}


-(void)checkScore{
    [_highScoreLabel setText:_scoreDataModel.highScoreString];
    [_highScoreLabel setHidden:NO];
    [_bestLabel setHidden:NO];
    [_restartButton setHidden:NO];
    [_mainMenuButton setHidden:NO];
    [_watchVideoButton setHidden:NO];
    [_facebookShareButton setHidden:NO];
    if (_scoreDataModel.highScore < _scoreDataModel.currentScore) {
        
    }else{

    }
    
    
}

-(IBAction)shareOnfacebook:(id)sender{
    
    BOOL hasUserLoggedIn = [[FacebookController sharedInstance]isUserLoggedInFacebook];
    void (^publishVideoBlock)() = ^void() {
        [[FacebookController sharedInstance]loginUserWithBlock:^{
            NSString *videoPath = [[CameraController sharedManager]currentVideoPath];
            [[FacebookController sharedInstance]publishVideoWithUrl:videoPath];
        }];
    };

    
    if (hasUserLoggedIn) {
        publishVideoBlock();
    }else{
        [self performSegueWithIdentifier:@"FacebookViewController" sender:publishVideoBlock];
        
    }
    
    /*
    
    
    [[FacebookController sharedInstance]loginUserWithBlock:^{
        NSString *videoPath = [[CameraController sharedManager]currentVideoPath];
        [[FacebookController sharedInstance]publishVideoWithUrl:videoPath];

    }];
    
    */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"FacebookViewController"]) {
        FacebookViewController *fbViewController = segue.destinationViewController;
        fbViewController.executeAfterLogin = sender;
    }

    
    
}

-(IBAction)restartGame:(id)sender{
    [self startSessions];
}
-(IBAction)gotoMainMenu:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)watchVideo:(id)sender{
    __weak ViewController *weakSelf = self;
    [_cameraController watchCurrentVideoForParentViewController:weakSelf];
}


- (void)listenForBlow:(NSTimer *)timer {
	[_recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
	if (lowPassResults > 0.95)
		NSLog(@"Mic blow detected");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _cameraController=[CameraController sharedManager];

    __weak UIView *weakView = self.view;
    [_cameraController setParentViewController:self];
   // [_cameraController addPreviewLayerOnView:weakView];
    [self addTestButton];
    [self startSessions];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [_cameraController resetCapture];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)dealloc{
    [self stopSessions];
}

-(void)stopSessions{
    [_recorder stop];
    _recorder=nil;
    
    [_flashLight lockForConfiguration:nil];
    [_flashLight setTorchMode:AVCaptureTorchModeOff];
    [_flashLight unlockForConfiguration];
    _flashLight=nil;
    
    [_levelTimer invalidate];
    _levelTimer=nil;
    
    [_checkCountdownTimer invalidate];
    _checkCountdownTimer=nil;
    
    ScreamingGameplayState=ScreamingNotStartedState;
    
    
    
    for (UIImageView *redImageView in _redLightsImageViewArray) {
            [redImageView setImage:nil];
    }
    
    for (UIImageView *yellowImageView in _yellowLightsImageViewArray) {
            [yellowImageView setImage:nil];
    }
    
    for (UIImageView *greenImageView in _greenLightsImageViewArray) {
            [greenImageView setImage:nil];
    }
    
        
        [_cameraController endCapture];
        [_cameraController stopCurrentPreview];
        [self checkScore];
    
}




-(void)startSessions{

    [self initCameraLight];
   // _levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(receivedPeakPower:) userInfo: nil repeats: YES];

    [self initAudio];
    _scoreDataModel=[[ScoreDataModel alloc]init];
    [_restartButton setHidden:YES];
    [_mainMenuButton setHidden:YES];
    [_watchVideoButton setHidden:YES];
    [_bestLabel setHidden:YES];
    [_highScoreLabel setHidden:YES];
    [_facebookShareButton setHidden:YES];
    
    ScreamingGameplayState=ScreamingNotStartedState;
    
    _currentScoreLabel.text = _scoreDataModel.currentScoreString;
    _checkCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkCountdown:) userInfo:nil repeats:YES];
    
    _startDate = [NSDate date];
    
    [_cameraController startCurrentVideoPreview];
    [_cameraController startCurrentVideoCapture];

}

-(void)addTestButton{
    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [testButton addTarget:self action:@selector(stopSessions) forControlEvents:UIControlEventTouchUpInside];
    [testButton setTitle:@"TestButton" forState:UIControlStateNormal];

    [self.view addSubview:testButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)disableAudio{
    NSError *error;
    [[AVAudioSession sharedInstance]setActive:NO error:&error];
}

-(void)initAudio{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }

    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
  	_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (_recorder) {
  		[_recorder prepareToRecord];
  		_recorder.meteringEnabled = YES;
  		[_recorder record];
        _levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];

  	} else
  		NSLog([error description]);

}

-(void)initCameraLight{
    /*
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 40.0f)];
    slider.maximumValue = 1.0f;
    slider.minimumValue = 0.0f;
    [slider setContinuous:YES];
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    */
    _flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([_flashLight isTorchAvailable] && [_flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [_flashLight lockForConfiguration:nil];
        if(success)
        {
      //      [_flashLight setTorchMode:AVCaptureTorchModeOn];
            [_flashLight unlockForConfiguration];
        }
    }

}

- (void)sliderDidChange:(UISlider *)slider
{
    _flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([_flashLight isTorchAvailable] && [_flashLight isTorchModeSupported:AVCaptureTorchModeOn]){
        [_flashLight lockForConfiguration:nil];
        if (slider.value==1) {
            [_flashLight setTorchModeOnWithLevel:AVCaptureMaxAvailableTorchLevel error:NULL];
        }else if(slider.value==0){
            [_flashLight setTorchMode:AVCaptureTorchModeOff];
        }else{
            [_flashLight setTorchModeOnWithLevel:slider.value error:NULL];
        }
        [_flashLight unlockForConfiguration];
    }
}


-(void)audioPeakPower:(Float32)peakPower andAudioAveragePower:(Float32)averagePower{
    //[self levelTimerCallback:nil];
    double peakPowerForChannel = pow(10, (0.05 * peakPower));
    const double ALPHA = 0.05;
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    _peakPowerForChannel=peakPowerForChannel;
}



@end
