//
//  FacebookController.m
//  ScreamMeter
//
//  Created by Amol Chaudhari on 2/17/14.
//  Copyright (c) 2014 Amol Chaudhari. All rights reserved.
//

#import "FacebookController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <Social/Social.h>
NS_ENUM(NSInteger, FacebookControllerState){
    UserNotLoggedIn,
    UserLoggedIn,
    ReadyToPostPictures
};

static FBLoginView* loginView;

@interface FacebookController ()<FBRequestDelegate,FBLoginViewDelegate>
{
    NSString *_currentVideoUrl;
    ACAccountStore *_accountStore;
    FBSession *_activeSession;
}
@property (nonatomic, retain) UIActivityIndicatorView *activitySpinner;


@end

@implementation FacebookController


+ (id)sharedInstance {
    static FacebookController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];

    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc]init];

    }
    return self;
}
- (void)applicationDidFinishLaunching:(UIApplication *)application{
    [FBLoginView class];
    [FBAppCall handleDidBecomeActive];

    /*
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open

                                      }];
     
}
     */
}

-(void)loginViewUser{
    if (!loginView) {
        loginView = [[FBLoginView alloc] initWithPermissions:
                     [NSArray arrayWithObjects:@"publish_stream",@"basic_info",nil]];
        loginView.frame = CGRectOffset(loginView.frame, 10, 10);
        [_parentViewController.view addSubview:loginView];
    }

}

- (void)loginUserWithBlock:(void (^)())blockName
{
    
    // If the session state is any of the two "open" states when the button is clicked
    
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
    _activeSession=[FBSession activeSession];
    NSArray *permissionCollection = [_activeSession permissions];
    BOOL hasPostingVideoPermission = NO;
    
    for (NSString *permission in permissionCollection) {
        
        if ([permission isEqualToString:@"publish_stream"]) {
            hasPostingVideoPermission=YES;
            break;
        }
    }
    
    if (_activeSession && _activeSession.isOpen && hasPostingVideoPermission) {
        blockName();
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             _activeSession=session;
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [self sessionStateChanged:session state:state error:error];

             if (state == FBSessionStateOpen && !error)
             {
                 _activeSession=session;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                    // blockName();
                     [self getPublishRights:^{
                         blockName();
                     }];
                 });
             }else if(error){
                 //some error
                 NSLog(@"There was error during read permissions %@",[error description]);
                 [[[UIAlertView alloc] initWithTitle:@"Failed to get Read permissions. Please try again."
                                             message:[error description]
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];

             }
         }];
    }
}



-(void)getPublishRights:(void (^)())block{
    NSArray* permissions = [[NSArray alloc] initWithObjects:
                            @"publish_stream", nil];
  //  NSAssert(_activeSession, @"Active session is not nil");
    
    if (!_activeSession) {
        _activeSession=[FBSession activeSession];
    }
    
    
    [_activeSession requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {

        if (!error) {
            block();
        }else{
            NSLog(@"Error with facebook %@",[error description]);
            [[[UIAlertView alloc] initWithTitle:@"Failed to get publish facebook permissions.Please try again"
                                        message:[error description]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];

        }
    }];
    
    /*
    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        // Retrieve the app delegate
        // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
        [self sessionStateChanged:session state:status error:error];
        if (!error) {
            block();
        }else{
            NSLog(@"Error with facebook %@",[error description]);
        }
    }];
    */
    
    

}

-(BOOL)isUserLoggedInFacebook{
    if (FBSession.activeSession.isOpen) {
        return YES;
    }
    return NO;
}

-(void)publishVideoWithUrl:(NSDictionary*)dataDictionary {

    
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activitySpinner = tempSpinner;
    _activitySpinner.center = [_parentViewController.view convertPoint:_parentViewController.view.center fromView:_parentViewController.view.superview];
    [_parentViewController.view addSubview:_activitySpinner];
    [_activitySpinner startAnimating];
    
   // FBSession *activeSession = [[FBSession activeSession] initWithPermissions:permissions];
    NSString *videoString = [dataDictionary objectForKey:@"videoUrl"];
    _currentVideoUrl=videoString;
    
    NSString *currentScore = [dataDictionary objectForKey:@"currentScore"];
   
    NSData *videoData = [NSData dataWithContentsOfFile:_currentVideoUrl];
    
    NSString *description = [NSMutableString stringWithFormat:@"BEAT MY SCORE : %@ .Download the app at http://goo.gl/NdSYYa",currentScore];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   videoData, @"ScreamMovie.mp4",
                                   @"video/quicktime", @"contentType",
                                   @"SCREAMMETER", @"title",
                                   description, @"description",
                                   nil];


    if (FBSession.activeSession.isOpen) {

            // Retrieve the app delegate
            // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
        dispatch_async(dispatch_get_main_queue(), ^{

            [self postVideoWithParameters:params];
        });

    }else{//We dont have active session open
        [[[UIAlertView alloc] initWithTitle:@"Failed to post the video. Please try again."
                                    message:@"No facebook session active."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        [_activitySpinner stopAnimating];
    }

}



-(void)postVideoWithParameters:(NSDictionary*)params{
    FBRequest *request = [FBRequest requestWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"result: %@, error: %@", result, error);
        [_activitySpinner stopAnimating];

        if (!error) {
            [[[UIAlertView alloc] initWithTitle:@"Successfully posted"
                                        message:@"Your Video has been posted successfully"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Failed to post the video. Please try again."
                                        message:[error description]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        
        
    }];

}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
       // [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
       // [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
           // [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
               // [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
               // [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
      //  [self userLoggedOut];
    }
}
    
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [FBSession.activeSession handleOpenURL:url];

    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
   // BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
   // return wasHandled;
}


#pragma mark FBLoginViewDelegate
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}




@end
