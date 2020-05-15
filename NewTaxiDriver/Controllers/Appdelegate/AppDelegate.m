//
//  AppDelegate.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "AlertViewController.h"
#import "TrackViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import "constant.h"
@import GoogleMaps;
@import GooglePlaces;
@import UIKit;
@import Firebase;
#import <FirebaseAuth.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@interface AppDelegate ()<FIRMessagingDelegate,UNUserNotificationCenterDelegate>
{
    NSUserDefaults *def;
    NSString *InstanceID;
}//AIzaSyClf7ZDgxIpUGNpD4J3ssR4Kv2yMmmB3Eg
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation AppDelegate
//AIzaSyBiaWEcaWth6e9gMiKAkshWFBE3DUN8ZP0  old
//AIzaSyCHMVl8cyzZ-KvgWjYkZraxeiMkiB9mfn0

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarHidden:false];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    NSLog(@"Width  :  %f",statusBar.frame.size.height);
//    statusBar.backgroundColor = [UIColor blackColor];
    _audioPlayer=nil;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"slow-spring-board"
                                         ofType:@"m4r"]];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [_audioPlayer prepareToPlay];
    }
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UDID  :  %@",uniqueIdentifier);
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter.currentNotificationCenter.delegate=self;
    } else {
        // Fallback on earlier versions
    }
    //AIzaSyCHMVl8cyzZ-KvgWjYkZraxeiMkiB9mfn0
    // Override point for customization after application launch.
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    [GMSServices provideAPIKey:@"AIzaSyC-9nq3DWNy4gSFclifDvWpE8cykzzyU5o"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyC-9nq3DWNy4gSFclifDvWpE8cykzzyU5o"];
//    [GMSServices provideAPIKey:@"AIzaSyCAf-LD9L4X1h-sMjO7bqg0RG5n9lvHIZA"];//New
//    [GMSPlacesClient provideAPIKey:@"AIzaSyBQANjtjKzHgjR-Ma3iSj7T-UoBwJMiFWo"];//Old
    [FIRApp configure];
    [Fabric.sharedSDK setDebug:YES];
    [Crashlytics.sharedInstance setUserEmail:@"latlontechnology@gmail.com"];
    [FIRMessaging messaging].delegate = self;
    NSLog(@"UDID  :  %@",[[FIRMessaging messaging]FCMToken]);
    NSString *fcmToken = [[FIRInstanceID instanceID] token];
    
NSLog(@"UDID  :  %@",fcmToken);
    def=[NSUserDefaults standardUserDefaults];
    [def setObject:[[FIRMessaging messaging]FCMToken] forKey:@"fcm"];
    [def synchronize];
//    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
//    [def setObject:@"1" forKey:@"view"];
//    [def synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
//        [self tokenRefreshNotification:];
 NSLog(@"On Off state  :  %@",[def valueForKey:@"onoff"]);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
     NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
     NSLog(@"applicationWillEnterForeground");
     [self checkridestatus];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRAuth auth] setAPNSToken:deviceToken type:FIRAuthAPNSTokenTypeUnknown];
    NSLog(@"UDID  :  %@",[[FIRMessaging messaging]FCMToken]);
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    def=[NSUserDefaults standardUserDefaults];
    [def setObject:deviceToken forKey:@"token"];
    [def setObject:[[FIRMessaging messaging]FCMToken] forKey:@"fcm"];
    [def synchronize];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}
-(void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
    def=[NSUserDefaults standardUserDefaults];
    [def setObject:fcmToken forKey:@"fcm"];
    [def synchronize];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Backkkk33333333");
    NSLog(@"Remote Notification  :  %@",userInfo);
    NSLog(@"Remote Notification  :  %@",[userInfo valueForKey:@"ride_id"]);
    NSLog(@"Remote Notification2 :  %@",[userInfo valueForKeyPath:@"aps.alert.body"]);
     def=[NSUserDefaults standardUserDefaults];
   

    NSLog(@"New Notification Ride id :  %@",[userInfo valueForKey:@"ride_id"]);
    NSLog(@"Old Notification Ride id :  %@",[def valueForKey:@"notifyrideid"]);
    if ([[def valueForKey:@"UserLogin"]isEqualToString:@"1"]||[[def valueForKey:@"UserLogin"]isEqual:@"1"]) {
 
    if ([[def valueForKey:@"onoff"] isEqual:@"0"]) {
        
    }
    else if ([[def valueForKey:@"onoff"] isEqual:@"2"]&&(![[userInfo valueForKey:@"ride_id"] isEqual:[def valueForKey:@"notifyrideid"]] || !([[userInfo valueForKey:@"ride_id"] isEqualToString:[def valueForKey:@"notifyrideid"]]))){
        
    }
    else if (([[userInfo valueForKeyPath:@"aps.alert.body"] isEqualToString:@"A new booking for you."] || [[userInfo valueForKeyPath:@"aps.alert.body"] isEqual:@"A new booking for you."])&&[[def valueForKey:@"onoff"] isEqual:@"2"]){
        
    }
    else {
        
        
            [_audioPlayer play];
        [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"notifyrideid"];
        [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"rideid"];
        [def setObject:[userInfo valueForKeyPath:@"aps.alert.body"] forKey:@"notifymsg"];
        [def synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AlertViewController *profile=[storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
    profile.notifymsg=[userInfo valueForKeyPath:@"aps.alert.body"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = profile;
    [self.window makeKeyAndVisible];
       
    }
    }
    else{
        
    }
    
//    }
     
  
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Backkkk1111111");
    NSLog(@"Remote Notification1  :  %@",userInfo);
    NSLog(@"Remote Notification  :  %@",[userInfo valueForKey:@"ride_id"]);
    NSLog(@"Remote Notification2 :  %@",[userInfo valueForKeyPath:@"aps.alert.body"]);
    def=[NSUserDefaults standardUserDefaults];
    
    
    NSLog(@"New Notification Ride id :  %@",[userInfo valueForKey:@"ride_id"]);
    NSLog(@"Old Notification Ride id :  %@",[def valueForKey:@"notifyrideid"]);
    if ([[def valueForKey:@"UserLogin"]isEqualToString:@"1"]||[[def valueForKey:@"UserLogin"]isEqual:@"1"]) {
        
        if ([[def valueForKey:@"onoff"] isEqual:@"0"]) {
            
        }
        else if ([[def valueForKey:@"onoff"] isEqual:@"2"]&&(![[userInfo valueForKey:@"ride_id"] isEqual:[def valueForKey:@"notifyrideid"]] || !([[userInfo valueForKey:@"ride_id"] isEqualToString:[def valueForKey:@"notifyrideid"]]))){
            
        }
        else if (([[userInfo valueForKeyPath:@"aps.alert.body"] isEqualToString:@"A new booking for you."] || [[userInfo valueForKeyPath:@"aps.alert.body"] isEqual:@"A new booking for you."])&&[[def valueForKey:@"onoff"] isEqual:@"2"]){
            
        }
        else {
            
            
            [_audioPlayer play];
            [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"notifyrideid"];
            [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"rideid"];
            [def setObject:[userInfo valueForKeyPath:@"aps.alert.body"] forKey:@"notifymsg"];
            [def synchronize];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AlertViewController *profile=[storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
            profile.notifymsg=[userInfo valueForKeyPath:@"aps.alert.body"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = profile;
            [self.window makeKeyAndVisible];
            
        }
    }
    else{
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)tokenRefreshNotification:(NSNotification *)notification {
    NSLog(@"instanceId_notification=>%@",[notification object]);
   InstanceID = [NSString stringWithFormat:@"%@",[notification object]];
    NSLog(@"instanceId_notification string=>%@",InstanceID);
    [def setObject:InstanceID forKey:@"fcm"];
    [def synchronize];
    [self connectToFcm];
}

- (void)connectToFcm {
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            
            NSLog(@"InstanceID_connectToFcm = %@", self->InstanceID);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self sendDeviceInfo];
                    NSLog(@"instanceId_tokenRefreshNotification22=>%@",[[FIRInstanceID instanceID] token]);
                    
                });
            });
            
            
        }
    }];
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"Backkkk22222222");
    //    completionHandler
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Foreground Val : %@",userInfo);
    NSLog(@"Remote Notification2  :  %@",[userInfo valueForKey:@"ride_id"]);
    NSLog(@"Remote Notification2 :  %@",[userInfo valueForKeyPath:@"aps.alert.body"]);
    def=[NSUserDefaults standardUserDefaults];
    if([UIApplication sharedApplication].applicationState==UIApplicationStateActive){
        
    if ([[def valueForKey:@"UserLogin"]isEqualToString:@"1"]||[[def valueForKey:@"UserLogin"]isEqual:@"1"]) {
        if ([[def valueForKey:@"onoff"] isEqual:@"0"]) {
            
        }
        else if ([[def valueForKey:@"onoff"] isEqual:@"2"]&&(![[userInfo valueForKey:@"ride_id"] isEqual:[def valueForKey:@"notifyrideid"]] || !([[userInfo valueForKey:@"ride_id"] isEqualToString:[def valueForKey:@"notifyrideid"]]))){
            
        }
        else if (([[userInfo valueForKeyPath:@"aps.alert.body"] isEqualToString:@"A new booking for you."] || [[userInfo valueForKeyPath:@"aps.alert.body"] isEqual:@"A new booking for you."])&&[[def valueForKey:@"onoff"] isEqual:@"2"]){
            
        }
        else {
            
//            completionHandler(UNNotificationPresentationOptionAlert);
            [_audioPlayer play];
            [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"notifyrideid"];
            [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"rideid"];
            [def setObject:[userInfo valueForKeyPath:@"aps.alert.body"] forKey:@"notifymsg"];
            [def synchronize];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AlertViewController *profile=[storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
            profile.notifymsg=[userInfo valueForKeyPath:@"aps.alert.body"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = profile;
            [self.window makeKeyAndVisible];
            
            //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
    else{
        
    }
    }
    else{
         if ([[def valueForKey:@"UserLogin"]isEqualToString:@"1"]||[[def valueForKey:@"UserLogin"]isEqual:@"1"]) {
             if([[def valueForKey:@"onoff"] isEqual:@"1"]){
    completionHandler(UNNotificationPresentationOptionAlert);
        [_audioPlayer play];
        [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"notifyrideid"];
        [def setObject:[userInfo valueForKey:@"ride_id"] forKey:@"rideid"];
        [def setObject:[userInfo valueForKeyPath:@"aps.alert.body"] forKey:@"notifymsg"];
        [def synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AlertViewController *profile=[storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
        profile.notifymsg=[userInfo valueForKeyPath:@"aps.alert.body"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = profile;
        [self.window makeKeyAndVisible];
             }
             else{
                 
             }
         }
         else{
             
         }
    }
}
-(void)checkridestatus{
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    //LQl_HVeTjyx02sTP4Sl
    //    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@",BASE_URL,@"getRideDetailsById",[def valueForKey:@"notifyrideid"]]];
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&driver_id=%@",BASE_URL,@"getRideDetailsById",[def valueForKey:@"notifyrideid"],[def valueForKey:@"driid"]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"Http Url  :  %@",urlRequest);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else{
            if(!error){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"Http Resp  :  %@",httpResponse);
                NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
                NSError *parseError = nil;
                if (data==nil || httpResponse.statusCode==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    });
                }
                
                else if(httpResponse.statusCode == 200)
                {
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    NSLog(@"Get Ride details The response is1 - %@",responseDictionary);
                    NSString *returnstring=[responseDictionary valueForKey:@"isError"];
                    BOOL error=[returnstring boolValue];
                    if (error==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *notifyridesta=[responseDictionary valueForKeyPath:@"response.ride_details.ride_status"];
                              if ([notifyridesta integerValue]==5){
                                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  AlertViewController *profile=[storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                                  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                                  self.window.rootViewController = profile;
                                  [self.window makeKeyAndVisible];
                            }
                            
                            
                        });
                    }
                    else{
                        
                    }
                    
                    
                }
                
               
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
        }
    }];
    [dataTask resume];
}
@end
