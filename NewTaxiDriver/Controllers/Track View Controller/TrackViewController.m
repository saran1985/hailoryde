//
//  TrackViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "TrackViewController.h"
#import "Constant.h"
#import "EndRideViewController.h"
#import "AppDelegate.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "CancelViewController.h"
#import "AlertViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import GoogleMaps;

@interface TrackViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    NSUserDefaults *def;
    AppDelegate *appDelegate;
    NSString *updatelat,*updatelon,*result,*location,*drioldlat,*drioldlon,*drinewlat,*drinewlon,*cabtype,*updateloc,*arrdriid;
    int check,loca,loccheck,postlocationval;
    NSString *arrtotdist,*arrtottime;
    __weak IBOutlet UIImageView *img_user;
    NSString *endcabfare,*endcabtype,*endfromlat,*endfromlon,*endfromloc,*endtolat,*endtolon,*endtoloc,*endpaytype,*endpaysta,*enduserid,*endtottime,*endtotdist,*endbasefare,*endbasedist,*endstarttime,*endtime,*endcreatedate,*arrfromlat,*arrfromlon,*arrtolat,*arrtolon,*stafromlat,*stafromlon,*statolat,*statolon,*arrfromloc,*arrtoloc,*stafromloc,*statoloc;
}//AIzaSyDfBnSUxYtm46greQE238ijaRvq4YBHGao
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusloc;
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusname;
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusmble;
@property(strong,nonatomic)IBOutlet UILabel *lbl_pick;
@property(strong,nonatomic)IBOutlet UILabel *lbl_drop;
@property(strong,nonatomic)IBOutlet UIView *view_call;
@property(strong,nonatomic)IBOutlet UIView *view_cancel;
@property(strong,nonatomic)IBOutlet UIButton *btn_arrived;
@property(strong,nonatomic)IBOutlet UIButton *btn_startride;
@property(strong,nonatomic)IBOutlet UIView *view_arrived;
@property(strong,nonatomic)IBOutlet UIView *view_startride;
@property (weak, nonatomic) IBOutlet UIImageView *img_call;
@property (weak, nonatomic) IBOutlet UIImageView *img_can;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *newlocation;
@property (nonatomic, retain) CLPlacemark *placemark;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *view_loc;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        _mapView.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, self.mapView.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//        
//    }
    [self homestopTimer];
    NSLog(@"TrackViewController  :  %@",_paytype);
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    check=0;
    loccheck=0;
    postlocationval=0;
    img_user.layer.cornerRadius = img_user.frame.size.width / 2;
    img_user.clipsToBounds = YES;
//    _btn_arrived.layer.cornerRadius=20;
    //    _btn_arrived.layer.borderColor=
    
    //    _btn_startride.layer.borderColor=
//    _btn_startride.layer.cornerRadius=20;
    
    //postLocationStatus
//    _view_call.layer.cornerRadius=20;
//    _view_cancel.layer.cornerRadius=20;
//    self.img_call.layer.cornerRadius = self.img_call.frame.size.width / 2;
//    self.img_call.clipsToBounds = YES;
//    self.img_can.layer.cornerRadius = self.img_can.frame.size.width / 2;
//    self.img_can.clipsToBounds = YES;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
        
    }
    else{
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"Location service disabled"
                                                           message:@"Turn on location"
                                                          delegate:nil
                                                 cancelButtonTitle:OKBUT
                                                 otherButtonTitles:nil];
        // alert.tag=1;
        //  alert.delegate=self;
        [alert show];
    }
    
    
    loca=0;
     dispatch_async(dispatch_get_main_queue(), ^{
         self->_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
         self->_loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
         [self.mapView addSubview:self->_loadingView];
     });
    
    // Do any additional setup after loading the view.
}
-(void)homestopTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([self->appDelegate.homepostLoc isValid]) {
            [self->appDelegate.homepostLoc invalidate];
            self->appDelegate.homepostLoc=nil;
        }
        else{
            [self->appDelegate.homepostLoc invalidate];
            self->appDelegate.homepostLoc=nil;
        }
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.homepostLoc isValid]) {
        [appDelegate.homepostLoc invalidate];
        appDelegate.homepostLoc=nil;
    }
    else{
        [appDelegate.homepostLoc invalidate];
        appDelegate.homepostLoc=nil;
    }
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
        
    }
    else{
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"Location service disabled"
                                                           message:@"Turn on location"
                                                          delegate:nil
                                                 cancelButtonTitle:OKBUT
                                                 otherButtonTitles:nil];
        // alert.tag=1;
        //  alert.delegate=self;
        [alert show];
    }
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(IBAction)call_doAction:(id)sender{
    def=[NSUserDefaults standardUserDefaults];
    if ([self->def valueForKey:@"cusmble"] == (id)[NSNull null]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:@"Cannot connect to call" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:CALL message:CALLDRI preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:YESBUT style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        /** What we write here???????? **/
                                        NSString *phoneNumber = [@"tel://" stringByAppendingString:[NSString stringWithFormat:@"%@",[self->def valueForKey:@"cusmble"]]];
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                        
                                        // call method whatever u need
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:NOBUT style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       /** What we write here???????? **/
                                       // call method whatever u need
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(IBAction)cancel_doAction:(id)sender{
    [self stopTimer];
    postlocationval=1;
//    def=[NSUserDefaults standardUserDefaults];
//    [def setObject:@"1" forKey:@"onoff"];
//    [def removeObjectForKey:@"notifyrideid"];
//    [def synchronize];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CancelViewController *cancel = [storyboard instantiateViewControllerWithIdentifier:@"CancelViewController"];
    [self presentViewController:cancel animated:YES completion:nil];
}
-(IBAction)arrived_doAction:(id)sender{
    if ([_btn_arrived.titleLabel.text isEqualToString:@"PICKUP"]||[_btn_arrived.titleLabel.text isEqual:@"PICKUP"]) {
       [self notifydriver];
    }
    else if ([_btn_arrived.titleLabel.text isEqualToString:@"START RIDE"]||[_btn_arrived.titleLabel.text isEqual:@"START RIDE"]) {
        [self notifydriver];
    }
    else{
        
    }
    
}
-(IBAction)startride_doAction:(id)sender{
    if ([_btn_startride.titleLabel.text isEqualToString:@"START RIDE"]||[_btn_startride.titleLabel.text isEqual:@"START RIDE"]) {
        [self notifydriver];
    }
    else if ([_btn_startride.titleLabel.text isEqualToString:@"END RIDE"]||[_btn_startride.titleLabel.text isEqual:@"END RIDE"]) {
        [self notifydriver];
    }
    else{
        
    }
}
-(void)arrived{
    @try {
    [self stopTimer];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.mapView addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSString *source = [_toloc stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"Base Url Val :  %@",source);
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",[def valueForKey:@"notifyrideid"],@"2",source]];
    //     NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",_rideid,@"2",_toloc]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Http Url  :  %@",urlRequest);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
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
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"The response is dict - %@",responseDictionary);
        self->arrtotdist=[responseDictionary valueForKeyPath:@"response.total_distance"];
        self->arrtottime=[responseDictionary valueForKeyPath:@"response.total_time"];
        self->arrdriid=[responseDictionary valueForKeyPath:@"response.driver_id"];
        NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"The response is - %@",returnstring);
        if (![self->arrdriid isEqual:[self->def valueForKey:@"driid"]]) {
            NSLog(@"Arrived ok");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:TRIPNOTACC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                NSLog(@"Error  :  %@",error);
                [self->_loadingView removeFromSuperview];
                [self->def setObject:@"1" forKey:@"onoff"];
                [self->def removeObjectForKey:@"notifyrideid"];
                [self->def synchronize];
                [self online];
            });
        }
        else{
            NSLog(@"Arrived cancel");
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            self->arrfromlat=[responseDictionary valueForKeyPath:@"response.frm_lat"];
            self->arrfromlon=[responseDictionary valueForKeyPath:@"response.frm_lng"];
            self->arrfromloc=[responseDictionary valueForKeyPath:@"response.from_location"];
            self->arrtolat=[responseDictionary valueForKeyPath:@"response.to_lat"];
            self->arrtolon=[responseDictionary valueForKeyPath:@"response.to_lng"];
            self->arrtoloc=[responseDictionary valueForKeyPath:@"response.to_location"];
            self->_ridestatus=@"2";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_mapView clear];
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.icon = [UIImage imageNamed:@"graycar.png"];
                double lat=[self->updatelat doubleValue];
                double lon=[self->updatelon doubleValue];
                marker.position = CLLocationCoordinate2DMake(lat,lon);
                marker.title = [NSString stringWithFormat:@"%@",@"Driver Location"];
                //                                              GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
                //                                              [mapView animateToCameraPosition:camera];
                marker.map = self->_mapView;
                
                GMSMarker *marker1 = [[GMSMarker alloc] init];
                marker1.icon = [UIImage imageNamed:@"pick.png"];
                double lat1=[self->arrfromlat doubleValue];
                double lon1=[self->arrfromlon doubleValue];
                marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
                marker1.title = [NSString stringWithFormat:@"%@",@"Customer Location"];
                marker1.map = self->_mapView;
//                GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
//                [self->_mapView animateToCameraPosition:camera1];
                 //first rele
//                self->_view_startride.hidden=NO;
//                [self->_view_arrived removeFromSuperview];
                [self->_mapView addSubview:self->_view_loc];
                [self->_btn_arrived setTitle:@"START RIDE" forState:UIControlStateNormal];
//                [self->_mapView addSubview:self->_view_startride];
                
                [self->_loadingView removeFromSuperview];
                [self drawRoute:self->updatelat:self->updatelon:self->arrfromlat:self->arrfromlon];
                self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                
                
//                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&zoom=14&views=traffic",[self->updatelat doubleValue],[self->updatelon doubleValue],[self->arrfromlat doubleValue],[self->arrfromlon doubleValue]]]];
//                } else {
//                    NSLog(@"Can't use comgooglemaps://");
//                    NSString *iTunesLink = @"https://apps.apple.com/us/app/google-maps-transit-food/id585027354";
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
//                }
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                NSLog(@"Error  :  %@",error);
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=1;
                [self stopTimer];
                [self login];
            });
        }
        else if (httpResponse.statusCode==403){
            dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error  :  %@",error);
            [self->_loadingView removeFromSuperview];
            [self->def setObject:@"1" forKey:@"onoff"];
            [self->def removeObjectForKey:@"notifyrideid"];
            [self->def synchronize];
            [self online];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
            [alert show];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSLog(@"Error  :  %@",error);
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [dataTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        self->_view_startride.hidden=NO;
    //        [self->_view_arrived removeFromSuperview];
    //        [self->_mapView addSubview:self->_lbl_cusloc ];
    //        [self->_mapView addSubview:self->_view_startride ];
    //    });
    
}
-(void)start{
    @try{
    [self stopTimer];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.mapView addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSString *source = [_toloc stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"Base Url Val :  %@",source);
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",[def valueForKey:@"notifyrideid"],@"3",source]];
    //     NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",_rideid,@"2",_toloc]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Http Url  :  %@",urlRequest);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
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
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        
        NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"The response is - %@",returnstring);
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            self->stafromlat=[responseDictionary valueForKeyPath:@"response.frm_lat"];
            self->stafromlon=[responseDictionary valueForKeyPath:@"response.frm_lng"];
            self->stafromloc=[responseDictionary valueForKeyPath:@"response.from_location"];
            self->statolat=[responseDictionary valueForKeyPath:@"response.to_lat"];
            self->statolon=[responseDictionary valueForKeyPath:@"response.to_lng"];
            self->statoloc=[responseDictionary valueForKeyPath:@"response.to_location"];
            self->_ridestatus=@"3";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_mapView clear];
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.icon = [UIImage imageNamed:@"graycar.png"];
                double lat=[self->stafromlat doubleValue];
                double lon=[self->stafromlon doubleValue];
                marker.position = CLLocationCoordinate2DMake(lat,lon);
                marker.title = [NSString stringWithFormat:@"%@",@"Driver Location"];
                marker.map = self->_mapView;
                
                GMSMarker *marker2 = [[GMSMarker alloc] init];
                marker2.icon = [UIImage imageNamed:@"graycar.png"];
                double lat2=[self->stafromlat doubleValue];
                double lon2=[self->stafromlon doubleValue];
                marker2.position = CLLocationCoordinate2DMake(lat2,lon2);
                marker2.title = [NSString stringWithFormat:@"%@",@"Pickup Location"];
                marker2.map = self->_mapView;
                //                                              GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
                //                                              [mapView animateToCameraPosition:camera];
                
                
                GMSMarker *marker1 = [[GMSMarker alloc] init];
                marker1.icon = [UIImage imageNamed:@"drop.png"];
                double lat1=[self->statolat doubleValue];
                double lon1=[self->statolon doubleValue];
                marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
                marker1.title = [NSString stringWithFormat:@"%@",@"Dropoff Location"];
                marker1.map = self->_mapView;
//                GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
//                [self->_mapView animateToCameraPosition:camera1];
                 //first rele
                [self->_view_arrived removeFromSuperview];
//                [self->_lbl_cusloc removeFromSuperview];
//                self->_lbl_cusloc.text=[NSString stringWithFormat:@"%@ mins to reach customer destination location",self->arrtottime];//change
                self->_view_startride.hidden=NO;
                [self->_btn_startride setTitle:@"END RIDE" forState:UIControlStateNormal];
                [self->_mapView addSubview:self->_view_startride ];
                [self->_loadingView removeFromSuperview];
                [self drawRoute:self->stafromlat:self->stafromlon:self->statolat:self->statolon];
                self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                
                
//                if ([[UIApplication sharedApplication] canOpenURL:
//                     [NSURL URLWithString:@"comgooglemaps://"]]) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&zoom=14&views=traffic",[self->stafromlat doubleValue],[self->stafromlon doubleValue],[self->statolat doubleValue],[self->statolon doubleValue]]]];
//                } else {
//                    NSLog(@"Can't use comgooglemaps://");
//                    NSString *iTunesLink = @"https://apps.apple.com/us/app/google-maps-transit-food/id585027354";
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
//                }
                /*
                 UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 EndRideViewController *end = [storyboard instantiateViewControllerWithIdentifier:@"EndRideViewController"];
                 [self presentViewController:end animated:YES completion:nil];
                 */
                
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                NSLog(@"Error  :  %@",error);
            });
        }
        else if (httpResponse.statusCode==403){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Error  :  %@",error);
                [self->_loadingView removeFromSuperview];
                [self->def setObject:@"1" forKey:@"onoff"];
                [self->def removeObjectForKey:@"notifyrideid"];
                [self->def synchronize];
               [self online];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=2;
                [self stopTimer];
                [self login];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSLog(@"Error  :  %@",error);
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [dataTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}
-(void)postLocationStatus{
    if (updatelat==nil || updatelon==nil) {
        
    }
    else{
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"postLocation"]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
//    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&latitude=%@&longitude=%@&online_status=%@",[def valueForKey:@"driid"],@"11.0168",@"76.9558",@"2"];
    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&latitude=%@&longitude=%@&online_status=%@",[def valueForKey:@"driid"],updatelat,updatelon,[def valueForKey:@"onoff"]];
    NSLog(@"Params  :  %@",userUpdate);
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:tot forHTTPHeaderField:@"Authorization"];
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
        }
        else{
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        if (data==nil || httpResponse.statusCode==0){
            
        }
        else if(httpResponse.statusCode == 200)
        {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"Track post loc Http Resp  :  %@",responseDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->drinewlat=[responseDictionary valueForKeyPath:@"response.driverLocations.latitude"];
                self->drinewlat=[responseDictionary valueForKeyPath:@"response.driverLocations.longitude"];
                self->drioldlat=[responseDictionary valueForKeyPath:@"response.driverLocations.old_latitude"];
                self->drioldlon=[responseDictionary valueForKeyPath:@"response.driverLocations.old_longitude"];
                [self newmarkerAnimation];
                [self->_loadingView removeFromSuperview];
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"The response dict is 500- %@",responseDictionary);
                NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"The response is 500- %@",returnstring);
                NSLog(@"Error  :  %@",error);
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=3;
                [self stopTimer];
                [self login];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                
                NSLog(@"Error  :  %@",error);
            });
        }
        }
    }];
    [dataTask resume];
    }
}
- (CLLocationManager *)locationManager
{
    
    if (_locationManager != nil)
    {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    
    return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _newlocation = locations.lastObject;
    NSLog(@"new coord :  %f", _newlocation.coordinate.latitude);
    self->updatelat=[NSString stringWithFormat:@"%f",_newlocation.coordinate.latitude];
    self->updatelon=[NSString stringWithFormat:@"%f",_newlocation.coordinate.longitude];
    [_mapView clear];
    GMSMarker *driverMarker=[[GMSMarker alloc]init];
    driverMarker.icon=[UIImage imageNamed:@"graycar.png"];
    driverMarker.position = CLLocationCoordinate2DMake(_newlocation.coordinate.latitude,_newlocation.coordinate.longitude);
    driverMarker.title=@"Driver Location";//this can be old position to make car movement to new position
    driverMarker.map = _mapView;
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_newlocation.coordinate.latitude
//                                                            longitude:_newlocation.coordinate.longitude
//                                                                 zoom:19];
//    [_mapView animateToCameraPosition:camera];
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(_newlocation.coordinate.latitude, _newlocation.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"new update address :  %@", response);
        GMSAddress *address =  response.firstResult;
        NSLog(@"XXX Update address  :  %@",address);
        if (address) {
            
            self->result = [NSString stringWithFormat:@"%@", [[address valueForKey:@"lines"] componentsJoinedByString:@" "]];
            self->location=address.locality;
            self->updateloc=[[address valueForKey:@"lines"]objectAtIndex:0];
            if ([self->location isEqual:@"Coimbatore"]) {
                // [_locationManager stopUpdatingLocation];
                //  [_loadingView removeFromSuperview];
                
                //                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self->_newlocation.coordinate.latitude
                //                                                                        longitude:self->_newlocation.coordinate.longitude
                //                                                                             zoom:19];
                //                [self->_mapView animateToCameraPosition:camera];
                
                
                
            }
            else{
            }
        }
        else{
            
        }
    }];
    CLLocation *oldLocation;
    if (locations.count > 1) {
        oldLocation = locations[locations.count - 2];
    }
    
    
    CLLocation *currentUserLocation = _newlocation;
    
    CLGeocoder *geocoder= [CLGeocoder new];
    
    [geocoder  reverseGeocodeLocation:currentUserLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            self->_placemark = [placemarks lastObject];
            NSNumber *lat = [NSNumber numberWithDouble:self->_newlocation.coordinate.latitude];
            NSNumber *lon =  [NSNumber numberWithDouble:self->_newlocation.coordinate.longitude];
            self->updatelat=[NSString stringWithFormat:@"%@",lat];
            self->updatelon=[NSString stringWithFormat:@"%@",lon];
            NSLog(@"yy location lat :%@" , currentUserLocation );
            NSLog(@"yy location lng :%@" , placemarks);
            //double delayInSeconds = 20.5;
            //            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            // Your code here
            //[self currentStatus];
            //            [self busy];
            //});
            //  [_loadingView removeFromSuperview];
            
            
        }
        else{
            
            
            
        }
        
    }
     
     ];
    if (loccheck==0) {
    if (_notifyid==1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:CUSCANRIDE delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
        _notifyid=0;
        def=[NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:@"notifyrideid"];
        [self->def setObject:@"1" forKey:@"onoff"];
        [self->def synchronize];
        [def synchronize];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
        [self presentViewController:alert11 animated:YES completion:nil];
    }
    else{
        [self setValues];
    }
         loccheck=1;
    }
    else{
        
    }
    if (postlocationval==1) {
        self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
        postlocationval=0;
    }
    else{
        
    }
    if ([self->_ridestatus integerValue]==1) {
        GMSMarker *marker1 = [[GMSMarker alloc] init];
        marker1.icon = [UIImage imageNamed:@"pick.png"];
        double lat1=[self->_fromlat doubleValue];
        double lon1=[self->_fromlon doubleValue];
        marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
        marker1.title = [NSString stringWithFormat:@"%@",@"Customer Location"];
        marker1.map = self->_mapView;
//        GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat1 longitude:lon1 zoom:19];
//        [self->_mapView animateToCameraPosition:camera1];
        [self drawRoute:self->updatelat:self->updatelon:self->_fromlat:self->_fromlon];
    }
    else if ([self->_ridestatus integerValue]==2) {
        GMSMarker *marker1 = [[GMSMarker alloc] init];
        marker1.icon = [UIImage imageNamed:@"pick.png"];
        double lat1=[self->_fromlat doubleValue];
        double lon1=[self->_fromlon doubleValue];
        marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
        marker1.title = [NSString stringWithFormat:@"%@",@"Customer Location"];
        marker1.map = self->_mapView;
//        GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat1 longitude:lon1 zoom:19];
//        [self->_mapView animateToCameraPosition:camera1];
        [self drawRoute:self->updatelat:self->updatelon:self->_fromlat:self->_fromlon];
    }
    else if ([self->_ridestatus integerValue]==3) {
        GMSMarker *marker1 = [[GMSMarker alloc] init];
        marker1.icon = [UIImage imageNamed:@"drop.png"];
        double lat1=[self->_tolat doubleValue];
        double lon1=[self->_tolon doubleValue];
        marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
        marker1.title = [NSString stringWithFormat:@"%@",@"Dropoff Location"];
        marker1.map = self->_mapView;
//        GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat1 longitude:lon1 zoom:19];
//        [self->_mapView animateToCameraPosition:camera1];
        [self drawRoute:self->updatelat:self->updatelon:self->_tolat:self->_tolon];
    }
    else{
        
    }
    NSLog(@"Post loc VAL : %D",postlocationval);
}
-(void)viewDidAppear:(BOOL)animated{
    
    // This padding will be observed by the mapView
    // mapVie.padding = UIEdgeInsetsMake(200, 0, 200, 0);
    
    _mapView.padding = UIEdgeInsetsMake(180 , 0, 180 , 0);
    
    
    
}

#pragma mark GMSMAPVIEW DELEGATE METHODS

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
    
    
}


- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
    
    
}
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    //    _loadingView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    [self.mapView addSubview:_loadingView];
    
    //    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake([updatelat doubleValue], [updatelon doubleValue]) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        GMSAddress *address =  response.firstResult;
        NSLog(@"Update Address : %@",address);
        if (address) {
            
            self->result = [NSString stringWithFormat:@"%@", [[address valueForKey:@"lines"] componentsJoinedByString:@" "]];
            self->location=address.locality;
            NSString *coun=address.country;
            if (([self->location isEqual:@"Coimbatore"] || [coun isEqual:@"Iraq"]||[coun isEqual:@"India"]||[self->location isEqual:@"كوامباتوري"] || [coun isEqual:@"الهند"] || [coun isEqual:@"العراق"])&& self->location){
                [self->_locationManager stopUpdatingLocation];
                //[_loadingView removeFromSuperview];
                
            }
            else{
                // [_locationManager startUpdatingLocation];
            }
        }
        else {
            
            //   [_locationManager startUpdatingLocation];
            
        }
        
        
    }];
    
}
-(void)newmarkerAnimation{
        int i=0;
    
        CLLocationCoordinate2D oldCoodinate = CLLocationCoordinate2DMake([drioldlat  doubleValue],[drioldlon  doubleValue]);
        CLLocationCoordinate2D newCoodinate = CLLocationCoordinate2DMake([drinewlat  doubleValue],[drinewlon  doubleValue]);
        dispatch_async(dispatch_get_main_queue(), ^{
            GMSMarker *driverMarker=[[GMSMarker alloc]init];
            driverMarker.groundAnchor = CGPointMake(0.0, 0.0);
            driverMarker.rotation = [self getHeadingForDirectionFromCoordinate:oldCoodinate toCoordinate:newCoodinate]; //found bearing value by calculation when marker add
            driverMarker.icon=[UIImage imageNamed:@"graycar.png"];
            driverMarker.position = newCoodinate; //this can be old position to make car movement to new position
            driverMarker.map = self->_mapView;
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:10.0] forKey:kCATransactionAnimationDuration];
            [CATransaction setCompletionBlock:^{
                driverMarker.groundAnchor = CGPointMake(0.5, 0.5);
                driverMarker.rotation = 0.5;
            }];
    
            driverMarker.position = newCoodinate; //this can be new position after car moved from old position to new position with animation
            driverMarker.map = self->_mapView;
            driverMarker.groundAnchor = CGPointMake(0.5, 0.5);
            driverMarker.rotation = [self getHeadingForDirectionFromCoordinate:oldCoodinate toCoordinate:newCoodinate]; //found bearing value by calculation
            //            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[newDriLat doubleValue] longitude:[newDriLon doubleValue] zoom:19];
            //            [mapView animateToCameraPosition:camera];
            [CATransaction commit];
        });
    
        if (i>=0) {
            i=0;
    
        }
        else {
            i=i+1;
        }
}
- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}
-(void)login{
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Login",LOGIN_URL]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSString *platform=[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    NSString *userUpdate =[NSString stringWithFormat:@"grant_type=%@&username=%@&password=%@&user_type=%@&device_id=%@&platform=%@",@"password",[def valueForKey:@"mobile"],[def valueForKey:@"password"],@"1",[def valueForKey:@"fcm"],platform];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        else{
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        if (httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            self->def=[NSUserDefaults standardUserDefaults];
            NSString *cab=[responseDictionary valueForKey:@"cab_type"];
            [self->def setObject:[responseDictionary valueForKey:@"access_token"] forKey:@"acc_tok"];
            [self->def setObject:[responseDictionary valueForKey:@"email"] forKey:@"email"];
            [self->def setObject:[responseDictionary valueForKey:@"expires_in"] forKey:@"exp_in"];
            [self->def setObject:[responseDictionary valueForKey:@"insurancenumber"] forKey:@"ins"];
            [self->def setObject:[responseDictionary valueForKey:@"licensenumber"] forKey:@"lic"];
            [self->def setObject:[responseDictionary valueForKey:@"mobile"] forKey:@"mobile"];
            [self->def setObject:[responseDictionary valueForKey:@"model"] forKey:@"model"];
            [self->def setObject:[responseDictionary valueForKey:@"name"] forKey:@"name"];
            [self->def setObject:[responseDictionary valueForKey:@"driver_id"] forKey:@"driid"];
            [self->def setObject:[responseDictionary valueForKey:@"token_type"] forKey:@"tok_type"];
            [self->def setObject:[responseDictionary valueForKey:@"platenumber"] forKey:@"plat"];
            [self->def setObject:[responseDictionary valueForKey:@"profile_image"] forKey:@"profile"];
            if (cab == (id)[NSNull null]){
                self->cabtype=@"";
            }
            else{
                self->cabtype=cab;
            }
            [self->def setObject:self->cabtype forKey:@"cabtype"];
            [self->def setObject:@"1" forKey:@"UserLogin"];
            [self->def synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                if (self->check==1) {
                    [self arrived];
                }
                else if (self->check==2){
                    [self start];
                }
                else if (self->check==3){
                    self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                }
                else if (self->check==4){
                    [self end];
                }
                else if (self->check==5){
                    [self image];
                }
                else if (self->check==6){
                    [self login];
                }
                else if (self->check==7){
                    [self notifydriver];
                }
                else if (self->check==8){
                    [self endonline];
                }
                else{
                    
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSLog(@"Error  :  %@",error);
            });
        }
        }
    }];
    [dataTask resume];
}
-(void)stopTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([self->appDelegate.postLoc isValid]) {
        [self->appDelegate.postLoc invalidate];
        self->appDelegate.postLoc=nil;
    }
    else{
        [self->appDelegate.postLoc invalidate];
        self->appDelegate.postLoc=nil;
    }
    });
}
-(void)end{
    @try{
    [self stopTimer];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.mapView addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    //    NSString *source = [_fromloc stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *source = _fromloc;
    NSString *destination;
    if (result==nil || result == (id)[NSNull null]||[result isEqualToString:@"(null)"]||[result isEqual:@"(null)"]) {
        destination = _toloc;
    }
    else{
        destination = result;
    }
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"completeTrip"]]];
    NSLog(@"Url Req  :  %@",urlRequest);
    
    NSDictionary *params = @{@"from_location" : source, @"to_location" : self->updateloc, @"ride_status" : @"4", @"ride_id" : [def valueForKey:@"notifyrideid"], @"to_lat" : self->updatelat, @"to_lng" : self->updatelon };
    
    //                             };
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"name=%@&password=%@&email=%@&mobile=%@&user_type=%@",_txt_name.text,_txt_pwd.text,_txt_mail.text,_txt_mble.text,@"2"];
    NSLog(@"User Update  :  %@",jsonInputString);
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Convert the String to Data
    NSData *data1 = [jsonInputString dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else{
        if(!error){
        NSDictionary *responseDictionary;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        NSError *parseError = nil;
        //            NSError *parseError = nil;
        responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //           returnstring = [returnstring stringByReplacingOccurrencesOfString:@"\\/" withString:@""];
        NSLog(@"The response is - %@",responseDictionary);
        NSLog(@"The response is - %@",returnstring);
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error=[returnstring boolValue];
            if (error==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    self->endcabfare=[responseDictionary valueForKeyPath:@"response.cab_fare"];
                    self->endcabtype=[responseDictionary valueForKeyPath:@"response.cab_type"];
                    self->endfromlat=[responseDictionary valueForKeyPath:@"response.frm_lat"];
                    self->endfromlon=[responseDictionary valueForKeyPath:@"response.frm_lng"];
                    self->endtolat=[responseDictionary valueForKeyPath:@"response.to_lat"];
                    self->endtolon=[responseDictionary valueForKeyPath:@"response.to_lng"];
                    self->endfromloc=[responseDictionary valueForKeyPath:@"response.from_location"];
                    self->endtoloc=[responseDictionary valueForKeyPath:@"response.to_location"];
                    self->endpaytype=[responseDictionary valueForKeyPath:@"response.payment_type"];
                    self->endstarttime=[responseDictionary valueForKeyPath:@"response.start_time"];
                    self->endtime=[responseDictionary valueForKeyPath:@"response.end_time"];
                    self->endcreatedate=[responseDictionary valueForKeyPath:@"response.created_date_time"];
                    self->enduserid=[responseDictionary valueForKeyPath:@"response.user_id"];
                    self->endtottime=[responseDictionary valueForKeyPath:@"response.total_time"];
                    self->endbasefare=[responseDictionary valueForKeyPath:@"response.base_fare"];
                    self->endbasedist=[responseDictionary valueForKeyPath:@"response.base_dist"];
                    self->endtotdist=[responseDictionary valueForKeyPath:@"response.total_distance"];
                    [self->def setObject:@"1" forKey:@"onoff"];
                    [self->def removeObjectForKey:@"notifyrideid"];
                    [self->def synchronize];
                    [self endonline];
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            
            
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                NSLog(@"Error  :  %@",error);
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=4;
                [self stopTimer];
                [self login];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSLog(@"Error  :  %@",error);
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [dataTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)setValues{
    @try {
     dispatch_async(dispatch_get_main_queue(), ^{
        [self->_loadingView removeFromSuperview];
        [self image];
        self->_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self->_loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.loadingView.alpha=0.9;
        [self.mapView addSubview:self->_loadingView];
        if ([self->_ridestatus integerValue]==1) {
            if (self->_imgdata.length==0||self->_imgdata==nil) {
                self->img_user.image = [UIImage imageNamed:@"profile.png"];
            }
            else {
                
                self->img_user.image=[UIImage imageWithData:self->_imgdata];
                
            }
            [self->_loadingView removeFromSuperview];
            [self->_mapView addSubview:self->_view_arrived];
            self->_view_arrived.hidden=NO;
            self->_view_startride.hidden=YES;
            self->_lbl_pick.text=[NSString stringWithFormat:@"%@",self->_fromloc];
            self->_lbl_drop.text=[NSString stringWithFormat:@"%@",self->_toloc];
            [self->_lbl_pick sizeToFit];
            self->_lbl_pick.lineBreakMode = NSLineBreakByWordWrapping;
            self->_lbl_pick.numberOfLines=2;
            [self->_lbl_pick sizeToFit];
            
            [self->_lbl_drop sizeToFit];
            self->_lbl_drop.lineBreakMode = NSLineBreakByWordWrapping;
            self->_lbl_drop.numberOfLines=2;
            [self->_lbl_drop sizeToFit];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.icon = [UIImage imageNamed:@"graycar.png"];
            double lat=[self->updatelat doubleValue];
            double lon=[self->updatelon doubleValue];
            marker.position = CLLocationCoordinate2DMake(lat,lon);
            marker.title = [NSString stringWithFormat:@"%@",@"Driver Location"];
            //                                              GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
            //                                              [mapView animateToCameraPosition:camera];
            marker.map = self->_mapView;
            
            GMSMarker *marker1 = [[GMSMarker alloc] init];
            marker1.icon = [UIImage imageNamed:@"pick.png"];
            double lat1=[self->_fromlat doubleValue];
            double lon1=[self->_fromlon doubleValue];
            marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
            marker1.title = [NSString stringWithFormat:@"%@",@"Pickup Location"];
            marker1.map = self->_mapView;
            GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat1 longitude:lon1 zoom:19];
            [self->_mapView animateToCameraPosition:camera1];
             //first rele
            self->_lbl_cusmble.text=[NSString stringWithFormat:@"%@",self->_cusmble];
            self->_lbl_cusname.text=[NSString stringWithFormat:@"%@",self->_cusname];
            [self drawRoute:self->updatelat:self->updatelon:self->_fromlat:self->_fromlon];
        }
        else if ([self->_ridestatus integerValue]==2) {
            [self->_mapView clear];
            if (self->_imgdata.length==0||self->_imgdata==nil) {
                self->img_user.image = [UIImage imageNamed:@"profile.png"];
            }
            else {
                
                self->img_user.image=[UIImage imageWithData:self->_imgdata];
                
            }
            self->_lbl_pick.text=[NSString stringWithFormat:@"%@",self->_fromloc];
            self->_lbl_drop.text=[NSString stringWithFormat:@"%@",self->_toloc];
            [self->_lbl_pick sizeToFit];
            self->_lbl_pick.lineBreakMode = NSLineBreakByWordWrapping;
            self->_lbl_pick.numberOfLines=2;
            [self->_lbl_pick sizeToFit];
            
            [self->_lbl_drop sizeToFit];
            self->_lbl_drop.lineBreakMode = NSLineBreakByWordWrapping;
            self->_lbl_drop.numberOfLines=2;
            [self->_lbl_drop sizeToFit];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.icon = [UIImage imageNamed:@"graycar.png"];
            double lat=[self->updatelat doubleValue];
            double lon=[self->updatelon doubleValue];
            marker.position = CLLocationCoordinate2DMake(lat,lon);
            marker.title = [NSString stringWithFormat:@"%@",@"Driver Location"];
            //                                              GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
            //                                              [mapView animateToCameraPosition:camera];
            marker.map = self->_mapView;
            
            GMSMarker *marker1 = [[GMSMarker alloc] init];
            marker1.icon = [UIImage imageNamed:@"pick.png"];
            double lat1=[self->_fromlat doubleValue];
            double lon1=[self->_fromlon doubleValue];
            marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
            marker1.title = [NSString stringWithFormat:@"%@",@"Customer Location"];
            marker1.map = self->_mapView;
            GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
            [self->_mapView animateToCameraPosition:camera1];
            //first rele
            [self->_loadingView removeFromSuperview];
//            self->_view_startride.hidden=NO;
            [self->_mapView addSubview:self->_view_arrived];
            self->_view_arrived.hidden=NO;
//            [self->_view_arrived removeFromSuperview];
            [self->_mapView addSubview:self->_view_loc ];
//            [self->_mapView addSubview:self->_view_startride ];
            [self->_btn_arrived setTitle:@"START RIDE" forState:UIControlStateNormal];
            self->_lbl_cusmble.text=[NSString stringWithFormat:@"%@",self->_cusmble];
            self->_lbl_cusname.text=[NSString stringWithFormat:@"%@",self->_cusname];            [self drawRoute:self->updatelat:self->updatelon:self->_fromlat:self->_fromlon];
        }
        else if ([self->_ridestatus integerValue]==3) {
            [self->_mapView clear];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.icon = [UIImage imageNamed:@"graycar.png"];
            double lat=[self->_fromlat doubleValue];
            double lon=[self->_fromlon doubleValue];
            marker.position = CLLocationCoordinate2DMake(lat,lon);
            marker.title = [NSString stringWithFormat:@"%@",@"Driver Location"];
            //                                              GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
            //                                              [mapView animateToCameraPosition:camera];
            marker.map = self->_mapView;
            
            GMSMarker *marker1 = [[GMSMarker alloc] init];
            marker1.icon = [UIImage imageNamed:@"drop.png"];
            double lat1=[self->_tolat doubleValue];
            double lon1=[self->_tolon doubleValue];
            marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
            marker1.title = [NSString stringWithFormat:@"%@",@"Dropoff Location"];
            marker1.map = self->_mapView;
            GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
            [self->_mapView animateToCameraPosition:camera1];
             //first rele
            self->_view_startride.hidden=NO;
            [self->_loadingView removeFromSuperview];
            [self->_view_arrived removeFromSuperview];
//            [self->_lbl_cusloc removeFromSuperview];
//            self->_lbl_cusloc.text=[NSString stringWithFormat:@"%@ mins to reach customer destination location",self->arrtottime];//change
            [self->_btn_startride setTitle:@"END RIDE" forState:UIControlStateNormal];
            [self->_mapView addSubview:self->_view_startride ];
            [self drawRoute:self->_fromlat:self->_fromlon:self->_tolat:self->_tolon];
        }
        else{
            [self->_loadingView removeFromSuperview];
        }
    });
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
- (void)drawRoute:(NSString *)originlat :(NSString *)originlon :(NSString *)destlat :(NSString *)destlon
{
    //[mapView clear];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"draw route");
        CLLocation *origin1 =  [[CLLocation alloc] initWithLatitude:originlat.doubleValue longitude:originlon.doubleValue];
        CLLocation *destination1 =  [[CLLocation alloc] initWithLatitude:destlat.doubleValue longitude:destlon.doubleValue];
        [self fetchPolylineWithOrigin:origin1 destination:destination1 completionHandler:^(GMSPolyline *polyline)
         {
             NSLog(@"if polylone");
             if(polyline){
                 polyline.map = self->_mapView;
             }
             else{
                 NSLog(@"else polylone");
                 //                 //POLYLINE
                 //                 GMSMutablePath *path = [GMSMutablePath path];
                 //                 [path addCoordinate:CLLocationCoordinate2DMake(picklat.doubleValue,picklon.doubleValue)];
                 //                 [path addCoordinate:CLLocationCoordinate2DMake(droplat.doubleValue,droplon.doubleValue)];
                 //
                 //                 GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
                 //                 //   rectangle.strokeWidth = 2.f;
                 //                 rectangle.strokeColor=[UIColor greenColor];
                 //                 rectangle.strokeWidth = 5.f;
                 //                 rectangle.map = _mapView;
                 //                 self.view=_mapView;
                 //                 //POLYLINE
             }
         }];
//        [self newmarkerAnimation];
    });
}

- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSLog(@"fetch polyine");
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving&key=AIzaSyDhQlBsFXWQTcezmSPdIPyCOd1wgPcsRkE", directionsAPI, originString, destinationString];//AIzaSyDsKF4BAve_8XGjUlHIcwkHEtjwM9TvCx4
    NSLog(@"fetch polyine api  :  %@",directionsUrlString);
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:directionsUrl];
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"N.A. result  :  %@",result);
        NSMutableArray *arrDistance=[result objectForKey:@"routes"];
        NSLog(@"N.A. Array result  :  %@",arrDistance);
        if ([arrDistance count]==0) {
            NSLog(@"N.A.");
        }
        else{
            NSMutableArray *arrLeg=[[arrDistance objectAtIndex:0]objectForKey:@"legs"];
            NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
            NSLog(@"%@",[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]]);
            if ([_ridestatus integerValue]==2) {
                _view_loc.hidden=NO;
                self->_lbl_cusloc.text=[NSString stringWithFormat:@"%@ to reach customer location",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]];
            }
            else if ([_ridestatus integerValue]==3){
                _view_loc.hidden=NO;
                self->_lbl_cusloc.text=[NSString stringWithFormat:@"%@ to reach customer destination",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]];
            }
        }
    }
    else{
        NSLog(@"N.A.");
        if ([_ridestatus integerValue]==2) {
            _view_loc.hidden=YES;
        }
        else if ([_ridestatus integerValue]==3){
            _view_loc.hidden=YES;
        }
    }
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         NSArray *routesArray = [json objectForKey:@"routes"];
                                                         
                                                         GMSPolyline *polyline = nil;
                                                         if ([routesArray count] > 0)
                                                         {
                                                             NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                             NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                             NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                             GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                             polyline = [GMSPolyline polylineWithPath:path];
                                                             polyline.strokeColor=[UIColor blackColor];
                                                             polyline.strokeWidth = 4.f;
                                                             
                                                         }
                                                         
                                                         
                                                         // run completionHandler on main thread
                                                         if(completionHandler)
                                                             completionHandler(polyline);
                                                     });
                                                 }];
    [fetchDirectionsTask resume];
}
-(void)image{
    check=5;
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@api/user/%@?userId=%@",LOGIN_URL,@"getBaseProfileImage",[def valueForKey:@"userid"]]];
    NSLog(@"driver Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    // add any additional headers or parameters
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        else{
        if (!error) {
            // do your response handling
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Http Resp  :  %@",httpResponse);
            NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Prof Img : %@",responseDictionary);
            if (httpResponse.statusCode==200) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *response1=[responseDictionary valueForKeyPath:@"response.image"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_imgdata = [self dataFromBase64EncodedString:response1];
                    if (self->_imgdata.length==0) {
                        self->img_user.image = [UIImage imageNamed:@"profile.png"];
                    }
                    else {
                        
                        self->img_user.image=[UIImage imageWithData:self->_imgdata];
                        
                    }
                    [self->_loadingView removeFromSuperview];
                    self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                });
                NSLog(@"Tot Resp  :  %@",response1);
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self stopTimer];
                    [self login];
                });
            }
            else if (httpResponse.statusCode==403){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    self->appDelegate.postLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        }
    }];
    [downloadTask resume];
}
-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}
-(void)online{
    @try {
    check=6;
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@&status=%@",BASE_URL,@"changeDriverStatus",[def valueForKey:@"driid"],@"1"]];
    NSLog(@"Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // add any additional headers or parameters
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else{
        if (!error) {
            // do your response handling
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Http Resp  :  %@",httpResponse);
            NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
            if (data==nil || httpResponse.statusCode==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            
            else if (httpResponse.statusCode==200) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Json1  :  %@",responseDictionary);
                NSLog(@"Json2  :  %@",returnstring);
                NSString *val=[responseDictionary valueForKey:@"isError"];
                BOOL iserror=[val boolValue];
                if(iserror ==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->def setObject:@"1" forKey:@"onoff"];
                        [self->def removeObjectForKey:@"notifyrideid"];
                        [self->def synchronize];
                        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                        [self presentViewController:alert11 animated:YES completion:nil];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self->_loadingView removeFromSuperview];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=6;
                    [self login];
                });
            }
            else if (httpResponse.statusCode==500){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    [self->_loadingView removeFromSuperview];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"online Json1  :  %@",responseDictionary);
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Driver status could not be updated" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    [self->_loadingView removeFromSuperview];
                });
            }
            // NSLog(@"Json3  :  %@",returnstring);
            //            NSArray * resultDict =[json objectForKey:@"name"];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [downloadTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)notifydriver{
    @try{
    [self stopTimer];
    check=7;
    def=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *driid1=[[NSMutableArray alloc]init];
    [driid1  addObject: self->_userid];
         NSLog(@"Can Tot dri  :  %@",driid1);
    NSLog(@"Ride Status  :  %@",_ridestatus);
    NSLog(@"Ride Id  :  %@",[def valueForKey:@"notifyrideid"]);
    NSLog(@"Cab Type  :  %@",self->_cabtype);
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSMutableURLRequest *urlRequest;
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&ride_id=%@&title=%@&message=%@",@"-LQCyPOl8ncU2QYzLTmX",[def valueForKey:@"rideid"],@"string",@"string"];
    //    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&ride_id=%@&title=%@&message=%@",driid,[def valueForKey:@"rideid"],@"string",@"string"];
    NSDictionary *params;
    urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"notifyDriver"]]];
    NSString *message;
    if ([_ridestatus integerValue]==1) {
        message=PICKNOT;
    }
    else if ([_ridestatus integerValue]==2){
        message=STANOT;
    }
    else if ([_ridestatus integerValue]==3){
        message=ENDNOT;
    }
    params = @{@"driver_id" : driid1 , @"ride_id" : [def valueForKey:@"notifyrideid"], @"title" : @"Taxi Driver", @"message" : message, @"cab_type" : self->_cabtype };
    
    
    //                             };
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"name=%@&password=%@&email=%@&mobile=%@&user_type=%@",_txt_name.text,_txt_pwd.text,_txt_mail.text,_txt_mble.text,@"2"];
    NSLog(@"User Update  :  %@",jsonInputString);
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Convert the String to Data
    NSData *data1 = [jsonInputString dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else{
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        if (!error) {
            if (data==nil || httpResponse.statusCode==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            
            else if(httpResponse.statusCode == 200)
            {
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"The response dict is - %@",responseDictionary);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self->_ridestatus integerValue]==1) {
                        [self arrived];
                    }
                    else if ([self->_ridestatus integerValue]==2){
                        [self start];
                    }
                    else if ([self->_ridestatus integerValue]==3){
                        [self end];
                        
                    }
                });
            }
            else if (httpResponse.statusCode==500){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSError *parseError = nil;
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    NSLog(@"The response dict is 500- %@",responseDictionary);
                    NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"The response is 500- %@",returnstring);
                    NSLog(@"Error  :  %@",error);
                    if ([self->_ridestatus integerValue]==1) {
                        [self arrived];
                    }
                    else if ([self->_ridestatus integerValue]==2){
                        [self start];
                    }
                    else if ([self->_ridestatus integerValue]==3){
                        [self end];
                        
                    }
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=7;
                    [self login];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    if ([self->_ridestatus integerValue]==1) {
                        [self arrived];
                    }
                    else if ([self->_ridestatus integerValue]==2){
                        [self start];
                    }
                    else if ([self->_ridestatus integerValue]==3){
                        [self end];
                        
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                if ([self->_ridestatus integerValue]==1) {
                    [self arrived];
                }
                else if ([self->_ridestatus integerValue]==2){
                    [self start];
                }
                else if ([self->_ridestatus integerValue]==3){
                    [self end];
                    
                }
            });
        }
        }
    }];
    [dataTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.postLoc isValid]) {
        [appDelegate.postLoc invalidate];
        appDelegate.postLoc=nil;
    }
    else{
        [appDelegate.postLoc invalidate];
        appDelegate.postLoc=nil;
    }
endcabfare=nil;endcabtype=nil;endfromlat=nil;endfromlon=nil;endfromloc=nil;endtolat=nil;endtolon=nil;endtoloc=nil;endpaytype=nil;endpaysta=nil;enduserid=nil;endtottime=nil;endtotdist=nil;endbasefare=nil;endbasedist=nil;endstarttime=nil;endtime=nil;endcreatedate=nil;arrfromlat=nil;arrfromlon=nil;arrtolat=nil;arrtolon=nil;stafromlat=nil;stafromlon=nil;statolat=nil;statolon=nil;arrfromloc=nil;arrtoloc=nil;stafromloc=nil;statoloc=nil;updatelat=nil;updatelon=nil;result=nil;location=nil;drioldlat=nil;drioldlon=nil;drinewlat=nil;drinewlon=nil;cabtype=nil;updateloc=nil;arrdriid=nil;
//     [_locationManager stopUpdatingLocation];
}
-(void)endonline{
    @try{
    [self stopTimer];
    check=8;
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@&status=%@",BASE_URL,@"changeDriverStatus",[def valueForKey:@"driid"],@"1"]];
    NSLog(@"Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // add any additional headers or parameters
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else{
        if (!error) {
            // do your response handling
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Http Resp  :  %@",httpResponse);
            NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
            if (data==nil || httpResponse.statusCode==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            
            else if (httpResponse.statusCode==200) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Json1  :  %@",responseDictionary);
                NSLog(@"Json2  :  %@",returnstring);
                NSString *val=[responseDictionary valueForKey:@"isError"];
                BOOL iserror=[val boolValue];
                if(iserror ==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->def setObject:@"1" forKey:@"onoff"];
                        [self->def removeObjectForKey:@"notifyrideid"];
                        [self->def synchronize];
                        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        EndRideViewController *end = [storyboard instantiateViewControllerWithIdentifier:@"EndRideViewController"];
                        end.date=self->endstarttime;
                        end.fromloc=self->endfromloc;
                        end.toloc=self->endtoloc;
                        end.paytype=self->endpaytype;
                        //                    end.amt=self->endbasefare;
                        end.amt=self->endcabfare;
                        [self presentViewController:end animated:YES completion:nil];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self->_loadingView removeFromSuperview];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=8;
                    [self login];
                });
            }
            else if (httpResponse.statusCode==500){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    [self->_loadingView removeFromSuperview];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"online Json1  :  %@",responseDictionary);
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Driver status could not be updated" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    [self->_loadingView removeFromSuperview];
                });
            }
            // NSLog(@"Json3  :  %@",returnstring);
            //            NSArray * resultDict =[json objectForKey:@"name"];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [downloadTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end

