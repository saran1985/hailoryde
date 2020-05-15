//
//  AlertViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "AlertViewController.h"
#import "Reachability.h"
#import "MyAccountViewController.h"
#import "MessageViewController.h"
#import "TrackViewController.h"
#import "Constant.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import GoogleMaps;
@import GooglePlaces;

@interface AlertViewController ()<CLLocationManagerDelegate,GMSMapViewDelegate,UIAlertViewDelegate>{
    NSUserDefaults *def;
    CLLocationCoordinate2D positions;
    NSString *name,*email,*mmble,*insnum,*licnum,*model,*pwd,*planum,*rate,*acc_sta,*pro_sta,*ver_sta,*chkstr,*cabtype1;
    __weak IBOutlet UIView *view_sub;
    int status,check,removeview,accept;
    NSString *dricurlat,*dricurlon,*drioldlat,*drioldlon,*drinewlat,*drinewlon,*resultAddr,*accdriid;
    AppDelegate *appDelegate;
    __weak IBOutlet UILabel *alertbook;
    NSString *basedist,*basefare,*cabfare,*cabtype,*bkdatetime,*fromlat,*fromlon,*fromloc,*tolat,*tolon,*toloc,*paysta,*paytype,*ridestatus,*totdist,*tottime,*userid,*rideid;
    __weak IBOutlet UILabel *alertCusname;
    NSString *notifycabfare,*notifycabtype,*notifyfromlat,*notifyfromlon,*notifyfromloc,*notifytolat,*notifytolon,*notifytoloc,*notifypaytype,*notifypaysta,*notifyridesta,*notifyuserid,*notifytottime,*notifytotdist,*notifybasefare,*notifybasedist,*notifysuername,*notifysuermble,*notifysueremail,*notifysuerdeciid,*notifyuserating,*notifycreatedate,*notifysuerdelsta,*notifysueraccsta,*notifysuerversta,*notifyuserprofimg;
    __weak IBOutlet UILabel *lbl_heading;
    GMSMarker *marker1,*marker2;
    int camerass;
}
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property(strong,nonatomic)IBOutlet UILabel *lbl_driname;
@property(strong,nonatomic)IBOutlet UILabel *lbl_dricarname;
@property(strong,nonatomic)IBOutlet UILabel *lbl_drinum;
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusname;
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusmble;
@property(strong,nonatomic)IBOutlet UILabel *lbl_totfare;
@property(strong,nonatomic)IBOutlet UILabel *lbl_pick;
@property(strong,nonatomic)IBOutlet UILabel *lbl_drop;
@property(strong,nonatomic)IBOutlet UIButton *btn_accept;
@property(strong,nonatomic)IBOutlet UIButton *btn_decline;
@property(strong,nonatomic)IBOutlet UIButton *btn_msg;
@property(strong,nonatomic)IBOutlet UIButton *btn_myAcc;
@property(strong,nonatomic)IBOutlet UIButton *btn_online;
@property(strong,nonatomic)IBOutlet UIImageView *img_dri;
@property(strong,nonatomic)IBOutlet UIImageView *img_cus;
@property(strong,nonatomic)IBOutlet UIView *view_subView;
@property(strong,nonatomic)IBOutlet UIView *view_alert;
@property(strong,nonatomic)IBOutlet UIView *view_accept;
@property(strong,nonatomic)IBOutlet UIView *view_decline;
@property (weak, nonatomic) IBOutlet UIImageView *img_acc;
@property (weak, nonatomic) IBOutlet UIImageView *img_dec;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *newlocation;
@property (nonatomic, retain) CLPlacemark *placemark;
@property (nonatomic, getter = isResultsLoaded) BOOL resultsLoaded;
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)
@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [Fabric with:@[[Crashlytics class]]];
//        NSString *j;
//        j=[NSString stringWithFormat:@"%@",1];
    camerass=0;
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        _mapView.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, self.mapView.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//        
//    }
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
   
    self.manWalkingImageView.animatedImage = manWalkingImage;
    //    [_mapView addSubview:_view_subView];
    check=0;
    status=0;
    //    _btn_online.layer.borderWidth=2;
    //    _btn_online.layer.borderColor=
    [_mapView addSubview:view_sub];
    [_mapView addSubview:_view_subView];
    [_mapView addSubview:_view_alert];
    _mapView.delegate=self;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
//    _mapView.padding = UIEdgeInsetsMake(154, 0, 374, 0);
    accept=0;
    _view_alert.hidden=YES;
    _view_subView.hidden=NO;
    lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
    removeview=0;
    self->def=[NSUserDefaults standardUserDefaults];
    [self->def setObject:@"0" forKey:@"removeview"];
    [self->def synchronize];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"TEST" message:[def valueForKey:@"notifyrideid"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alert show];
    NSLog(@"View did load : %@",[def valueForKey:@"notifyrideid"]);
//    _view_alert.layer.borderColor=[[UIColor colorWithRed:242.0/255.0 green:195.0/255.0 blue:31.0/255.0 alpha:1.0] CGColor];
//    _view_alert.layer.borderWidth=2;
//    _view_alert.layer.cornerRadius=10;
//    _view_alert.clipsToBounds=YES;
//    _view_accept.layer.cornerRadius=20;
//    _view_decline.layer.cornerRadius=20;
//    self.img_acc.layer.cornerRadius = self.img_acc.frame.size.width / 2;
//    self.img_acc.clipsToBounds = YES;
//    self.img_dec.layer.cornerRadius = self.img_dec.frame.size.width / 2;
//    self.img_dec.clipsToBounds = YES;
    [self profiles];
    //[_mapView addSubview:_view_subView];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.postLoc isValid]) {
        [appDelegate.postLoc invalidate];
        appDelegate.postLoc=nil;
    }
    else{
        [appDelegate.postLoc invalidate];
        appDelegate.postLoc=nil;
    }
//    _mapView.padding = UIEdgeInsetsMake(124, 40, 174, 40);
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
        
    }
    else{
        UIAlertView    *alert = [[UIAlertView alloc]initWithTitle:@"Location service disabled" message:@"Turn on location" delegate:nil cancelButtonTitle:OKBUT otherButtonTitles:nil];
        // alert.tag=1;
        //  alert.delegate=self;
        [alert show];
        //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"app-settings:"]];
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
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)userlocations{
    
    NSLog(@"locations :%@" , userlocations);
    
//    [_locationManager stopUpdatingLocation];
    
//    if ([self isResultsLoaded])
//    {
//        return;
//    }
//
//    [self setResultsLoaded:YES];
    
    
    _newlocation = userlocations.lastObject;
    NSLog(@"did update locations :%@" , _newlocation);
    
    
    
    //    if (locations.count > 1) {
    //        oldLocation = locations[locations.count - 2];
    //    }
    
    
    
    
    
    [_mapView clear];
//    if ([self->notifyridesta integerValue]==0) {
    if (removeview!=0) {
        self->marker2 = [[GMSMarker alloc] init];
        self->marker2.icon = [UIImage imageNamed:@"pick.png"];
        double lat=[self->notifyfromlat doubleValue];
        double lon=[self->notifyfromlon doubleValue];
        self->marker2.position = CLLocationCoordinate2DMake(lat,lon);
        self->marker2.title = [NSString stringWithFormat:@"%@",@"Pickup Location"];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
        [self->_mapView animateToCameraPosition:camera];
        self->marker2.map = self->_mapView;
        
        self->marker1 = [[GMSMarker alloc] init];
        self->marker1.icon = [UIImage imageNamed:@"drop.png"];
        double lat1=[self->notifytolat doubleValue];
        double lon1=[self->notifytolon doubleValue];
        self->marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
        self->marker1.title = [NSString stringWithFormat:@"%@",@"Dropoff Location"];
        self->marker1.map = self->_mapView;
    }
    else{
        self->marker1.map=nil;
        self->marker2.map=nil;
    }
    GMSMarker *driverMarker=[[GMSMarker alloc]init];
    driverMarker.icon=[UIImage imageNamed:@"graycar.png"];
    driverMarker.position = CLLocationCoordinate2DMake(_newlocation.coordinate.latitude,_newlocation.coordinate.longitude); //this can be old position to make car movement to new position
    driverMarker.map = _mapView;
    if (camerass==0) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_newlocation.coordinate.latitude
                                                                longitude:_newlocation.coordinate.longitude
                                                                     zoom:19];
        [_mapView animateToCameraPosition:camera];
        camerass=1;
    }
    else{

    }
   
    self->dricurlat=[NSString stringWithFormat:@"%f",_newlocation.coordinate.latitude];
    self->dricurlon=[NSString stringWithFormat:@"%f",_newlocation.coordinate.longitude];
//    _mapView.padding = UIEdgeInsetsMake(0, 0, 20, 0);
//     _mapView.padding = UIEdgeInsetsMake(124, 40, 174, 40);
    CLLocation *currentUserLocation = _newlocation;
    
    CLGeocoder *geocoder= [CLGeocoder new];
    
    [geocoder  reverseGeocodeLocation:currentUserLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
        if (error == nil && [placemarks count] > 0) {
            self->_placemark = [placemarks lastObject];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self->_newlocation.coordinate.latitude , self->_newlocation.coordinate.longitude);
            
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = @"My Location";
            
            
            
            
            
            
            
                        
            NSLog(@"Location  :  %@",self->_placemark.locality);
            
//            self->dricurlat=str1;
//            self->dricurlon=str2;
            NSLog(@"dri cur lat and lon :%@\n%@" , self->dricurlat,self->dricurlon);
            // [self driverCurrentstatus];
            
            
            // [_locationManager stopUpdatingLocation];
        }
        else{
            
            
            //  [_locationManager startUpdatingLocation];
            
        }
        
    }
     ];
}

-(void)mapView:(GMSMapView* )mapView didChangeCameraPosition:(GMSCameraPosition* )position{
    positions =   CLLocationCoordinate2DMake(mapView.camera.target.latitude ,mapView.camera.target.longitude);
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(positions.latitude, positions.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        GMSAddress *address;
        
        address = response.firstResult;
        
        NSString *strCountry = [address valueForKey:@"country"];
        
        NSString *strl = [address valueForKey:@"locality"];
        
        NSLog(@"User Country Change : %@",strCountry);
        NSLog(@"User Location Change : %@",strl);
        //NSString *strLines = [address valueForKey:@"lines"];
        NSNumber *latitude = [NSNumber numberWithDouble:mapView.camera.target.latitude];
        NSNumber *longitude = [NSNumber numberWithDouble:mapView.camera.target.longitude];
        
        NSString *str1 = [NSString stringWithFormat:@"%f", [latitude doubleValue]];
        NSString *str2 = [NSString stringWithFormat:@"%f", [longitude doubleValue]];
        self->dricurlat = str1;
        self->dricurlon = str2;
        self->resultAddr = [NSString stringWithFormat:@"%@", [[address valueForKey:@"lines"] componentsJoinedByString:@" "]];
        
        NSLog(@"super result version 5.0 : %@" , self->resultAddr);
        
        
        
        
    }];
}
- (void)mapView:(GMSMapView* )mapView idleAtCameraPosition:(GMSCameraPosition* )position {
    GMSReverseGeocodeCallback __block handler = ^(GMSReverseGeocodeResponse* response, NSError* error) {
        //     [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"Handler : %@",handler);
        GMSAddress *address;
        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            NSLog(@"Location Services Enabled");
        }
        address = response.firstResult;
        NSString *strCountry = [address valueForKey:@"country"];
        NSString *strl = [address valueForKey:@"locality"];
        NSLog(@"User Country : %@",strCountry);
        NSLog(@"User Location : %@",strl);
    };
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:positions completionHandler:handler];
}
-(void)viewDidAppear:(BOOL)animated{
//    _mapView.padding = UIEdgeInsetsMake(124, 40, 174, 40);
//    This padding will be observed by the mapView
//    _mapView.padding = UIEdgeInsetsMake(180 , 0, 180 , 0);
      _mapView.padding = UIEdgeInsetsMake(154, 0, 374, 0);
//    _mapView.padding = UIEdgeInsetsMake(-350 , 0, -350 , 0);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(IBAction)myAcc_doAction:(id)sender{
    [self stopTimer];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyAccountViewController *myAcc = [storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
    [self presentViewController:myAcc animated:YES completion:nil];
}
-(IBAction)msg_doAction:(id)sender{
    [self stopTimer];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *message = [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    [self presentViewController:message animated:YES completion:nil];
}
-(IBAction)onoff_doAction:(id)sender{
    if (status==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ONLINE message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:YESBUT,NOBUT, nil];
        alert.tag=2;
        alert.delegate=self;
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:OFFLINE message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:YESBUT,NOBUT, nil];
        alert.tag=1;
        alert.delegate=self;
        [alert show];
    }
}
-(IBAction)accept_doAction:(id)sender{
    [self accept];
}
-(IBAction)decline_doAction:(id)sender{
//    [self.view_alert removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->def=[NSUserDefaults standardUserDefaults];
        [self->def removeObjectForKey:@"removeview"];
        [self->def removeObjectForKey:@"notifyrideid"];
        [self->def synchronize];
        self->accept=0;
        self->removeview=0;
        self->marker1.map=nil;
        self->marker2.map=nil;
        self->_view_alert.hidden=YES;
        self->_view_subView.hidden=NO;
        self->lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
    [self online];
    });
//    [_blackView removeFromSuperview];
}
-(void)profiles{
    @try{
    def = [NSUserDefaults standardUserDefaults];
    NSLog(@"onoff val : %@",[self->def valueForKey:@"onoff"]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_lbl_driname.text = [NSString stringWithFormat:@"%@",[self->def valueForKey:@"name"]];
        self->_lbl_dricarname.text = [NSString stringWithFormat:@"%@ | %@",[self->def valueForKey:@"model"],[self->def valueForKey:@"cabtype"]];
        self->_lbl_drinum.text = [NSString stringWithFormat:@"%@",[self->def valueForKey:@"plat"]];
        self.img_dri.layer.cornerRadius = self.img_dri.frame.size.width / 2;
        self.img_dri.clipsToBounds = YES;
        if ([[self->def valueForKey:@"onoff"] isEqualToString:@"1"] || [[self->def valueForKey:@"onoff"] isEqual:@"1"]) {
            self->_btn_online.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:84.0/255.0 blue:40.0/255.0 alpha:1.0];
            [self->_btn_online setTitle:@"GO OFFLINE" forState:UIControlStateNormal];
            self->status=1;
            [self currentStatus];
//            [self online];
        }
        else if ([[self->def valueForKey:@"onoff"] isEqualToString:@"2"] || [[self->def valueForKey:@"onoff"] isEqual:@"2"]) {
            self->_btn_online.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:84.0/255.0 blue:40.0/255.0 alpha:1.0];
            [self->_btn_online setTitle:@"GO OFFLINE" forState:UIControlStateNormal];
            self->status=2;
            [self currentStatus];
//            [self busy];
        }
        else if ([[self->def valueForKey:@"onoff"] isEqualToString:@"0"] || [[self->def valueForKey:@"onoff"] isEqual:@"0"]) {
            self->_btn_online.backgroundColor=[UIColor colorWithRed:134.0/255.0 green:0.0/255.0 blue:9.0/255.0 alpha:1.0];
            [self->_btn_online setTitle:@"GO ONLINE" forState:UIControlStateNormal];
            self->status=0;
            [self offline];
        }
        else{
            self->_btn_online.backgroundColor=[UIColor colorWithRed:134.0/255.0 green:0.0/255.0 blue:9.0/255.0 alpha:1.0];
            [self->_btn_online setTitle:@"GO ONLINE" forState:UIControlStateNormal];
            self->status=0;
            [self offline];
        }
//        [self image];
        if (![self->def valueForKey:@"newprofile"]||[[self->def valueForKey:@"newprofile"] isEqual:(id)[NSNull null]]) {
            self.img_dri.image= [UIImage imageNamed:@"profile.png"];
        }
//        else{
        NSData *imageData = [self->def valueForKey:@"newprofile"];
        //                NSData *imageData = [[NSData alloc]initWithBase64EncodedString:response1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (imageData.length==0) {
            self.img_dri.image= [UIImage imageNamed:@"profile.png"];
        }
        else {
            
            self.img_dri.image=[UIImage imageWithData:imageData];
            
        }
        NSLog(@"Id  :  %@",[self->def valueForKey:@"notifyrideid"]);
//        }
        
    });
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1 && buttonIndex==0) {
        [self offline];
    }
    else if (alertView.tag==2 && buttonIndex==0){
        [self online];
    }
}
-(void)online{
    @try{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self stopTimer];
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
                        [self->def synchronize];
                        self->_btn_online.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:84.0/255.0 blue:40.0/255.0 alpha:1.0];
                        [self->_btn_online setTitle:@"GO OFFLINE" forState:UIControlStateNormal];
                        self->status=1;
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
                    self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    self->appDelegate.homepostLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                    [self->_loadingView removeFromSuperview];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=3;
                    [self stopTimer];
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
-(void)offline{
    @try{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self stopTimer];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@&status=%@",BASE_URL,@"changeDriverStatus",[def valueForKey:@"driid"],@"0"]];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(iserror ==0){
                        [self stopTimer];
                        [self->def setObject:@"0" forKey:@"onoff"];
                        [self->def synchronize];
                        self->_btn_online.backgroundColor=[UIColor colorWithRed:134.0/255.0 green:0.0/255.0 blue:9.0/255.0 alpha:1.0];
                        [self->_btn_online setTitle:@"GO ONLINE" forState:UIControlStateNormal];
                        self->status=0;
                    }
                    else{
                        NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                        
                    }
                    [self->_loadingView removeFromSuperview];
                    //            self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    //            self->appDelegate.homepostLoc=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                    // NSLog(@"Json3  :  %@",returnstring);
                    //            NSArray * resultDict =[json objectForKey:@"name"];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=4;
                    [self stopTimer];
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
                    NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    [self->_loadingView removeFromSuperview];
                });
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
    [downloadTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)currentStatus{
    @try {
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@",BASE_URL,@"checkCurrentRide",[def valueForKey:@"driid"]]];
    NSLog(@"Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    NSLog(@"total : %@",tot);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // add any additional headers or parameters
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                if ([self->def valueForKey:@"notifyrideid"]) {
                    [self userDetails];
                }
                else{
                    [self online];
                }
            });
        }
        else{
        if (!error) {
            // do your response handling
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Http Resp  :  %@",httpResponse);
            NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
            // id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            //NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Current Ride Json1  :  %@",responseDictionary);
            if (httpResponse.statusCode==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    if ([self->def valueForKey:@"notifyrideid"]) {
                        [self userDetails];
                    }
                    else{
                        [self online];
                    }
                });
            }
            else if (httpResponse.statusCode==200) {
                NSString *returnstring=[responseDictionary valueForKey:@"isError"];
                BOOL error1=[returnstring boolValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSLog(@"Current Ride Json1  :  %@",[self->def valueForKey:@"notifyrideid"]);
                    if (error1==0) {
                        if ([self->def valueForKey:@"notifyrideid"]) {
                            [self userDetails];
                        }
                        else{
                            [self online];
                        }
                        //                        [self nearestDriver];
                        //                        self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        //                        self->appDelegate.homepostLoc=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                        //                        _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                        //                        _loadingView.backgroundColor=[UIColor blackColor];
                        //                        self.loadingView.alpha=0.7;
                        //                        [self.mapView addSubview:_loadingView];
                    }
                    else{
                        if ([self->def valueForKey:@"notifyrideid"]) {
                            [self userDetails];
                        }
                        else{
                            [self online];
                        }
                        NSString *error=[responseDictionary valueForKey:@"errorMessage"];
                        NSLog(@"Login FAILURE");
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:error message:error delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    }
                    
                });
                
                
            }
            else if (httpResponse.statusCode==400){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    if ([self->def valueForKey:@"notifyrideid"]) {
                        [self userDetails];
                    }
                    else{
                        [self online];
                    }
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=1;
                    [self stopTimer];
                    [self login];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    if ([self->def valueForKey:@"notifyrideid"]) {
                        [self userDetails];
                    }
                    else{
                        [self online];
                    }
                });
            }
            // NSLog(@"Json3  :  %@",returnstring);
            //            NSArray * resultDict =[json objectForKey:@"name"];
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                if ([self->def valueForKey:@"notifyrideid"]) {
                    [self userDetails];
                }
                else{
                    [self online];
                }
            });
        }
        }
            /*
          dispatch_async(dispatch_get_main_queue(), ^{
          if ([[self->def valueForKey:@"view"] isEqualToString:@"1"] || [[self->def valueForKey:@"view"] isEqual:@"1"]) {
          self.blackView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
          self->_blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
          [self.view addSubview:self->_blackView];
          self->_view_alert.center=CGPointMake(self.blackView.frame.size.width/2, self.blackView.frame.size.height/2);
          [self.blackView addSubview:self.view_alert];
          }
          else{
          
          }
          });*/
    }];
    [downloadTask resume];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)userDetails{
    @try {
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self stopTimer];
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
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            [self stopTimer];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"Get Ride details The response is1 - %@",responseDictionary);
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error=[returnstring boolValue];
            if (error==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->notifytolat=[responseDictionary valueForKeyPath:@"response.ride_details.to_lat"];
                    self->notifyuserid=[responseDictionary valueForKeyPath:@"response.ride_details.user_id"];
                    self->notifytoloc=[responseDictionary valueForKeyPath:@"response.ride_details.to_location"];
                    self->notifytolon=[responseDictionary valueForKeyPath:@"response.ride_details.to_lng"];
                    self->notifypaysta=[responseDictionary valueForKeyPath:@"response.ride_details.payment_status"];
                    self->notifycabfare=[responseDictionary valueForKeyPath:@"response.ride_details.cab_fare"];
                    self->notifycabtype=[responseDictionary valueForKeyPath:@"response.ride_details.cab_type"];
                    self->notifyfromlat=[responseDictionary valueForKeyPath:@"response.ride_details.frm_lat"];
                    self->notifyfromloc=[responseDictionary valueForKeyPath:@"response.ride_details.from_location"];
                    self->notifyfromlon=[responseDictionary valueForKeyPath:@"response.ride_details.frm_lng"];
                    self->notifypaytype=[responseDictionary valueForKeyPath:@"response.ride_details.payment_type"];
                    self->notifyridesta=[responseDictionary valueForKeyPath:@"response.ride_details.ride_status"];
                    self->notifycreatedate=[responseDictionary valueForKeyPath:@"response.ride_details.created_date_time"];
                    self->notifytotdist=[responseDictionary valueForKeyPath:@"response.ride_details.total_distance"];
                    self->notifytottime=[responseDictionary valueForKeyPath:@"response.ride_details.total_time"];
                    self->notifybasedist=[responseDictionary valueForKeyPath:@"response.ride_details.base_dist"];
                    self->notifybasefare=[responseDictionary valueForKeyPath:@"response.ride_details.base_fare"];
                    self->notifysuermble=[responseDictionary valueForKeyPath:@"response.user_details.mobile"];
                    self->notifysuername=[responseDictionary valueForKeyPath:@"response.user_details.name"];
                    self->notifysueremail=[responseDictionary valueForKeyPath:@"response.user_details.email"];
                    self->notifyuserating=[responseDictionary valueForKeyPath:@"response.user_details.rating"];
                    self->notifysueraccsta=[responseDictionary valueForKeyPath:@"response.user_details.account_status"];
                    self->notifysuerdeciid=[responseDictionary valueForKeyPath:@"response.user_details.device_id"];
                    self->notifysuerdelsta=[responseDictionary valueForKeyPath:@"response.user_details.delete_status"];
                    self->notifysuerversta=[responseDictionary valueForKeyPath:@"response.user_details.verify_status"];
//                    self->notifyuserprofimg=[responseDictionary valueForKeyPath:@"response.user_details.profile_image"];
//                    [self->def setObject:self->notifyuserprofimg forKey:@"userimg"];
                    [self->def setObject:self->notifysuermble forKey:@"cusmble"];
                    [self->def setObject:self->notifysuername forKey:@"cusname"];
                    [self->def setObject:self->ridestatus forKey:@"cusridesta"];
                    [self->def synchronize];
                    self->_img_cus.layer.cornerRadius = self->_img_cus.frame.size.width / 2;
                    self->_img_cus.clipsToBounds = YES;
                    self->_lbl_cusmble.text=[NSString stringWithFormat:@"%@",self->notifysuermble];
                    self->_lbl_cusname.text=[NSString stringWithFormat:@"%@",self->notifysuername];
                    self->_lbl_totfare.text=[NSString stringWithFormat:@"CAD %@",self->notifycabfare];
                    self->_lbl_pick.text=[NSString stringWithFormat:@"%@",self->notifyfromloc];
                    self->_lbl_drop.text=[NSString stringWithFormat:@"%@",self->notifytoloc];
                    self->alertCusname.text=[NSString stringWithFormat:@"%@",self->notifysuername];
                    self->alertbook.text=[NSString stringWithFormat:@"%@",self->notifycreatedate];
                    [self->_lbl_pick sizeToFit];
                    self->_lbl_pick.lineBreakMode = NSLineBreakByWordWrapping;
                    [self->_lbl_pick sizeToFit];
                    
                    [self->_lbl_drop sizeToFit];
                    self->_lbl_drop.lineBreakMode = NSLineBreakByWordWrapping;
                    [self->_lbl_drop sizeToFit];
//                    NSData *imageData = [self dataFromBase64EncodedString:self->notifyuserprofimg];
//                    if (imageData.length==0) {
//                        self->_img_cus.image = [UIImage imageNamed:@"profile.png"];
//                    }
//                    else {
//
//                        self->_img_cus.image=[UIImage imageWithData:imageData];
//
//                    }
                    if ([self->notifyridesta integerValue]==0 || [self->notifyridesta integerValue]==6) {
                        self->marker2 = [[GMSMarker alloc] init];
                        self->marker2.icon = [UIImage imageNamed:@"pick.png"];
                        double lat=[self->notifyfromlat doubleValue];
                        double lon=[self->notifyfromlon doubleValue];
                        self->marker2.position = CLLocationCoordinate2DMake(lat,lon);
                        self->marker2.title = [NSString stringWithFormat:@"%@",@"Pickup Location"];
                        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
                        [self->_mapView animateToCameraPosition:camera];
                        self->marker2.map = self->_mapView;
                        
                        self->marker1 = [[GMSMarker alloc] init];
                        self->marker1.icon = [UIImage imageNamed:@"drop.png"];
                        double lat1=[self->notifytolat doubleValue];
                        double lon1=[self->notifytolon doubleValue];
                        self->marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
                        self->marker1.title = [NSString stringWithFormat:@"%@",@"Dropoff Location"];
                        self->marker1.map = self->_mapView;
                        
                        self->def=[NSUserDefaults standardUserDefaults];
                        [self->def setObject:@"1" forKey:@"removeview"];
                        [self->def synchronize];
                        self->accept=1;
                        self->_view_alert.hidden=NO;
                        self->_view_subView.hidden=YES;
                        self->lbl_heading.text=[NSString stringWithFormat:@"Trip Request"];
                        [self->_loadingView removeFromSuperview];
                        self->removeview=1;
                        [self performSelector:@selector(hideloadingview) withObject:nil afterDelay:60.0];
                    }
                    else if ([self->notifyridesta integerValue]==5){
                        self->def=[NSUserDefaults standardUserDefaults];
                        [self->def setObject:@"0" forKey:@"removeview"];
                        [self->def synchronize];
                        self->accept=0;
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:CUSCANRIDE delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                        self->status=1;
                        [self->def removeObjectForKey:@"notifyrideid"];
                        [self->def setObject:@"1" forKey:@"onoff"];
                        [self->def synchronize];
                        [self stopTimer];
                        [self online];
                        [self->_loadingView removeFromSuperview];
                    }
                    else if ([self->notifyridesta integerValue]==4){
                        self->def=[NSUserDefaults standardUserDefaults];
                        [self->def setObject:@"0" forKey:@"removeview"];
                        [self->def synchronize];
                        self->accept=0;
                        [self stopTimer];
                        self->status=1;
                        [self->def removeObjectForKey:@"notifyrideid"];
                        [self->def setObject:@"1" forKey:@"onoff"];
                        [self->def synchronize];
                        [self->_loadingView removeFromSuperview];
                        [self online];
                    }
                    else if([self->notifyridesta integerValue]==1||[self->notifyridesta integerValue]==2||[self->notifyridesta integerValue]==3){
                        self->def=[NSUserDefaults standardUserDefaults];
                        [self->def setObject:@"0" forKey:@"removeview"];
                        [self->def setObject:@"2" forKey:@"onoff"];
                        [self->def synchronize];
                        self->accept=0;
                        [self stopTimer];
                        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        TrackViewController *track = [storyboard instantiateViewControllerWithIdentifier:@"TrackViewController"];
                        track.rideid=[self->def valueForKey:@"ride_id"];
                        track.basedist=self->notifybasedist;
                        track.basefare=self->notifybasefare;
                        track.cabfare=self->notifycabfare;
                        track.cabtype=self->notifycabtype;
                        track.bkdatetime=self->notifycreatedate;
                        track.fromlat=self->notifyfromlat;
                        track.fromlon=self->notifyfromlon;
                        track.fromloc=self->notifyfromloc;
                        track.tolat=self->notifytolat;
                        track.tolon=self->notifytolon;
                        track.toloc=self->notifytoloc;
                        track.paysta=self->notifypaysta;
                        track.paytype=self->notifypaytype;
                        track.ridestatus=self->notifyridesta;
                        track.totdist=self->notifytotdist;
                        track.tottime=self->notifytottime;
                        track.userid=self->notifyuserid;
                        track.cusname=[self->def valueForKey:@"cusname"];
                        track.cusmble=[self->def valueForKey:@"cusmble"];
                        [self presentViewController:track animated:YES completion:nil];
                        [self->_loadingView removeFromSuperview];
                    }
                    else{
                            [self->_loadingView removeFromSuperview];
                            [self online];
                    }
                    
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
               [self->_loadingView removeFromSuperview];
                    [self online];
                });
            }
            
            
        }
        else if (httpResponse.statusCode==400||httpResponse.statusCode==204){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [self->_loadingView removeFromSuperview];
                NSLog(@"The response dict is 400- %@",responseDictionary);
                [self online];
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"The accept response dict is 500- %@",responseDictionary);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                NSLog(@"Error  :  %@",error);
                [self online];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
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
                NSLog(@"The accept response dict is 500- %@",responseDictionary);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                [self online];
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
-(void)login{
    [self stopTimer];
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
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if(httpResponse.statusCode == 200)
        {
            self->def=[NSUserDefaults standardUserDefaults];
            NSString *acc_tok = [responseDictionary valueForKey:@"access_token"];
            NSString *email=[responseDictionary valueForKey:@"email"];
            NSString *exp_in=[responseDictionary valueForKey:@"expires_in"];
            NSString *ins_num=[responseDictionary valueForKey:@"insurancenumber"];
            NSString *lic_num=[responseDictionary valueForKey:@"licensenumber"];
            NSString *mble=[responseDictionary valueForKey:@"mobile"];
            NSString *model=[responseDictionary valueForKey:@"model"];
            NSString *name=[responseDictionary valueForKey:@"name"];
            NSString *driid=[responseDictionary valueForKey:@"driver_id"];
            NSString *tok_typ=[responseDictionary valueForKey:@"token_type"];
            NSString *cab=[responseDictionary valueForKey:@"cab_type"];
            NSString *plat_num=[responseDictionary valueForKey:@"platenumber"];
            [self->def setObject:acc_tok forKey:@"acc_tok"];
            [self->def setObject:email forKey:@"email"];
            [self->def setObject:exp_in forKey:@"exp_in"];
            [self->def setObject:ins_num forKey:@"ins"];
            [self->def setObject:lic_num forKey:@"lic"];
            [self->def setObject:mble forKey:@"mobile"];
            [self->def setObject:model forKey:@"model"];
            [self->def setObject:name forKey:@"name"];
            [self->def setObject:driid forKey:@"driid"];
            [self->def setObject:tok_typ forKey:@"tok_type"];
            [self->def setObject:plat_num forKey:@"plat"];
            if (cab == (id)[NSNull null]){
                self->cabtype1=@"";
            }
            else{
                self->cabtype1=cab;
            }
            [self->def setObject:self->cabtype1 forKey:@"cabtype"];
            [self->def setObject:@"1" forKey:@"UserLogin"];
            [self->def synchronize];
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error1=[returnstring boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error1==0) {
                    //                    UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully register to driver" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    //                    [alert1 show];
                    if (self->check ==1) {
                        [self currentStatus];
                    }
                    else if (self->check==2){
                        [self accept];
                    }
                    else if (self->check==3){
                        [self online];
                    }
                    else if (self->check==4){
                        [self offline];
                    }
                    else if (self->check==5){
                                                self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                self->appDelegate.homepostLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                    }
                    else if (self->check==6){
                        [self image];
                    }
                    else if (self->check==7){
                        [self busy];
                    }
                    else if (self->check==8){
                        [self acceptcheck];
                    }
                    else if (self->check==9){
                        [self notifydriver];
                    }
                    else{
                        
                    }
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->_loadingView removeFromSuperview];
                    });
                }
                
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        }
    }];
    [dataTask resume];
    
}
-(void)postLocationStatus{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.mapView clear];
//    });
    if(dricurlat==nil || dricurlon==nil){
        
    }
    else{
    NSString *strsta;
    strsta=[NSString stringWithFormat:@"%d",status];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"postLocation"]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
//        NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&latitude=%@&longitude=%@&online_status=%@",[def valueForKey:@"driid"],@"11.0168",@"76.9558",@"1"];
    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&latitude=%@&longitude=%@&online_status=%@",[def valueForKey:@"driid"],dricurlat,dricurlon,strsta];
    NSLog(@"Update  :  %@",userUpdate);
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        if (data==nil || httpResponse.statusCode==0){
            
        }
        
        else if(httpResponse.statusCode == 200)
        {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"Alert post loc Http Resp  :  %@",responseDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->drinewlat=[responseDictionary valueForKeyPath:@"response.driverLocations.latitude"];
                self->drinewlon=[responseDictionary valueForKeyPath:@"response.driverLocations.longitude"];
                self->drioldlat=[responseDictionary valueForKeyPath:@"response.driverLocations.old_latitude"];
                self->drioldlon=[responseDictionary valueForKeyPath:@"response.driverLocations.old_longitude"];
                NSLog(@"Dri new lat  :  %@",self->drinewlat);
                NSLog(@"Dri cur lat  :  %@",self->dricurlat);
//                self->drioldlat=@"11.0265";
//                self->drioldlon=@"77.1313";
//                                [self newmarkerAnimation];
                [self->_loadingView removeFromSuperview];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=5;
                [self stopTimer];
                [self login];
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
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                
                NSLog(@"Error  :  %@",error);
            });
        }
    }];
    [dataTask resume];
    }
}
-(void)stopTimer{
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
-(void)newmarkerAnimation{
//    [_mapView clear];
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
-(void)accept{
    @try{
    self->def=[NSUserDefaults standardUserDefaults];
    [self->def setObject:@"0" forKey:@"removeview"];
    [self->def synchronize];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self stopTimer];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&driverId=%@",BASE_URL,@"acceptTripRequest",[def valueForKey:@"notifyrideid"],[def valueForKey:@"driid"]]];
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
        NSLog(@"Accept Http Code  :  %ld",(long)httpResponse.statusCode);
        NSError *parseError = nil;
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            [self stopTimer];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"Accept The response is1 - %@",responseDictionary);
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error=[returnstring boolValue];
            if (error==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopTimer];
                    [self->def setObject:@"2" forKey:@"onoff"];
                    [self->def synchronize];
                    self->status=2;
                    self->marker1.map=nil;
                    self->marker2.map=nil;
                    self->accept=0;
                    self->removeview=0;
                    self->_view_alert.hidden=YES;
                    self->_view_subView.hidden=NO;
                    self->lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
//                    [self.view_alert removeFromSuperview];
//                    [self->_blackView removeFromSuperview];
                    self->basedist=[responseDictionary valueForKeyPath:@"response.base_dist"];
                    self->basefare=[responseDictionary valueForKeyPath:@"response.base_fare"];
                    self->cabfare=[responseDictionary valueForKeyPath:@"response.cab_fare"];
                    self->cabtype=[responseDictionary valueForKeyPath:@"response.cab_type"];
                    self->bkdatetime=[responseDictionary valueForKeyPath:@"response.created_date_time"];
                    self->fromlat=[responseDictionary valueForKeyPath:@"response.frm_lat"];
                    self->fromlon=[responseDictionary valueForKeyPath:@"response.frm_lng"];
                    self->fromloc=[responseDictionary valueForKeyPath:@"response.from_location"];
                    self->tolat=[responseDictionary valueForKeyPath:@"response.to_lat"];
                    self->tolon=[responseDictionary valueForKeyPath:@"response.to_lng"];
                    self->toloc=[responseDictionary valueForKeyPath:@"response.to_location"];
                    self->paysta=[responseDictionary valueForKeyPath:@"response.payment_status"];
                    self->paytype=[responseDictionary valueForKeyPath:@"response.payment_type"];
                    self->ridestatus=[responseDictionary valueForKeyPath:@"response.ride_status"];
                    self->totdist=[responseDictionary valueForKeyPath:@"response.total_distance"];
                    self->tottime=[responseDictionary valueForKeyPath:@"response.total_time"];
                    self->userid=[responseDictionary valueForKeyPath:@"response.user_id"];
                    [self->def setObject:self->userid forKey:@"userid"];
                    [self->def synchronize];
                    [self->_loadingView removeFromSuperview];
                    [self acceptcheck];
                });
            }
            else{
                [self->def setObject:@"1" forKey:@"onoff"];
                [self->def synchronize];
                self->status=1;
            }
            
            
        }
        else if (httpResponse.statusCode==400){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                [self online];
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                [self online];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                self->check=2;
                [self stopTimer];
                [self login];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                self->def=[NSUserDefaults standardUserDefaults];
//                [self->_loadingView removeFromSuperview];
//                [self.view_alert removeFromSuperview];
//                [self->_blackView removeFromSuperview];
                self->marker1.map=nil;
                self->marker2.map=nil;
                self->_view_alert.hidden=YES;
                self->_view_subView.hidden=NO;
                self->accept=0;
                self->removeview=0;
                self->lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
                [self->def removeObjectForKey:@"removeview"];
                [self->def removeObjectForKey:@"notifyrideid"];
                [self->def synchronize];
                NSLog(@"Error  :  %@",error);
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"The accept response dict is 500- %@",responseDictionary);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                [self online];
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
/*-(void)updatetrip{
 check=6;
 [self stopTimer];
 def=[NSUserDefaults standardUserDefaults];
 NSString *acctok=[def valueForKey:@"acc_tok"];
 NSString *toktyp=[def valueForKey:@"tok_type"];
 NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
 NSString *source = [toloc stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
 NSLog(@"Base Url Val :  %@",source);
 NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",[def valueForKey:@"notifyrideid"],@"1",source]];
 //     NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",_rideid,@"2",_toloc]];
 //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
 
 NSLog(@"Http Url  :  %@",urlRequest);
 NSURLSession *session = [NSURLSession sharedSession];
 
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
 
 [request setHTTPMethod:@"PUT"];
 
 [request setValue:tot forHTTPHeaderField:@"Authorization"];
 NSLog(@"total : %@",tot);
 [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
 NSLog(@"Http Resp  :  %@",httpResponse);
 NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
 NSError *parseError = nil;
 
 if(httpResponse.statusCode == 200)
 {
 NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
 NSLog(@"update trip The response is dict - %@",responseDictionary);
 NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"update trip The response is - %@",returnstring);
 dispatch_async(dispatch_get_main_queue(), ^{
 [self->_loadingView removeFromSuperview];
 UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 TrackViewController *track = [storyboard instantiateViewControllerWithIdentifier:@"TrackViewController"];
 track.rideid=self->rideid;
 track.basedist=self->basedist;
 track.basefare=self->basefare;
 track.cabfare=self->cabfare;
 track.cabtype=self->cabtype;
 track.bkdatetime=self->bkdatetime;
 track.fromlat=self->fromlat;
 track.fromlon=self->fromlon;
 track.fromloc=self->fromloc;
 track.tolat=self->tolat;
 track.tolon=self->tolon;
 track.toloc=self->toloc;
 track.paysta=self->paysta;
 track.paytype=self->paytype;
 track.ridestatus=self->ridestatus;
 track.totdist=self->totdist;
 track.tottime=self->tottime;
 track.userid=self->userid;
 [self presentViewController:track animated:YES completion:nil];
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
 self->check=6;
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
 }];
 [dataTask resume];
 //    dispatch_async(dispatch_get_main_queue(), ^{
 //        self->_view_startride.hidden=NO;
 //        [self->_view_arrived removeFromSuperview];
 //        [self->_mapView addSubview:self->_lbl_cusloc ];
 //        [self->_mapView addSubview:self->_view_startride ];
 //    });
 
 
 }*/
-(void)image{
    @try{
    check=6;
    //-LQ8ppkPCzkywOEjPq4z
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"getBaseProfileImage",[def valueForKey:@"driid"]]];
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
                    NSData *imageData = [self dataFromBase64EncodedString:response1];
                    if (imageData.length==0) {
                        self->_img_dri.image = [UIImage imageNamed:@"profile.png"];
                    }
                    else {
                        
                        self->_img_dri.image=[UIImage imageWithData:imageData];
                        
                    }
                    
                });
                NSLog(@"Tot Resp  :  %@",response1);
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=6;
                [self stopTimer];
                [self login];
                });
            }
            else{
                
            }
        }
        else{
            
        }
        }
    }];
    [downloadTask resume];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)busy{
    @try{
    check=7;
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self stopTimer];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@&status=%@",BASE_URL,@"changeDriverStatus",[def valueForKey:@"driid"],@"2"]];
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
                        [self->def setObject:@"2" forKey:@"onoff"];
                        [self->def synchronize];
                        self->status=2;
                        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        TrackViewController *track = [storyboard instantiateViewControllerWithIdentifier:@"TrackViewController"];
                        track.rideid=self->rideid;
                        track.basedist=self->basedist;
                        track.basefare=self->basefare;
                        track.cabfare=self->cabfare;
                        track.cabtype=self->cabtype;
                        track.bkdatetime=self->bkdatetime;
                        track.fromlat=self->fromlat;
                        track.fromlon=self->fromlon;
                        track.fromloc=self->fromloc;
                        track.tolat=self->tolat;
                        track.tolon=self->tolon;
                        track.toloc=self->toloc;
                        track.paysta=self->paysta;
                        track.paytype=self->paytype;
                        track.ridestatus=self->ridestatus;
                        track.totdist=self->totdist;
                        track.tottime=self->tottime;
                        track.userid=self->userid;
                        track.cusname=[self->def valueForKey:@"cusname"];
                        track.cusmble=[self->def valueForKey:@"cusmble"];
                        [self presentViewController:track animated:YES completion:nil];
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
                    self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    self->appDelegate.homepostLoc=[NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
                    [self->_loadingView removeFromSuperview];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=7;
                    [self stopTimer];
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
-(void)hideloadingview{
    self->def=[NSUserDefaults standardUserDefaults];
     dispatch_async(dispatch_get_main_queue(), ^{
         if ([[self->def valueForKey:@"removeview"] isEqualToString:@"1"]||[[self->def valueForKey:@"removeview"] isEqual:@"1"]) {
//             [self->_mapView clear];
             self->marker1.map=nil;
             self->marker2.map=nil;
             NSLog(@"IFF Remove");
             [self->def removeObjectForKey:@"removeview"];
             [self->def removeObjectForKey:@"notifyrideid"];
             [self->def synchronize];
             self->accept=0;
             self->_view_alert.hidden=YES;
             self->_view_subView.hidden=NO;
             self->lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
             self->removeview=0;
             [self online];
         }
         else{
              NSLog(@"ELSE Remove");
//             self->removeview=1;
//             [self userDetails];
         }
         
     });
}
-(void)acceptcheck{
    @try{
    check=8;
    def=[NSUserDefaults standardUserDefaults];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self stopTimer];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@",BASE_URL,@"getDetailsByRideId",[def valueForKey:@"notifyrideid"]]];
    
    
    NSLog(@"Http Url Val :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    
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
            NSDictionary *responseDictionary1 = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"Ind Ride Details  Values Json1  :  %@",responseDictionary1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data==nil || httpResponse.statusCode==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->_loadingView removeFromSuperview];
                        
                       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    });
                }
                
                else if (httpResponse.statusCode==200) {
                    [self->_loadingView removeFromSuperview];
                    self->accdriid=[responseDictionary1 valueForKeyPath:@"response.ride_details.driver_id"];
                    if (![self->accdriid isEqual:[self->def valueForKey:@"driid"]]) {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:TRIPNOTACC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                        self->marker1.map=nil;
                        self->marker2.map=nil;
                        self->accept=0;
                        self->_view_alert.hidden=YES;
                        self->_view_subView.hidden=NO;
                        self->lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
                        self->removeview=0;
                        NSLog(@"Error  :  %@",error);
                        [self->_loadingView removeFromSuperview];
                        [self->def setObject:@"1" forKey:@"onoff"];
                        [self->def removeObjectForKey:@"notifyrideid"];
                        [self->def synchronize];
                        [self online];
                    }
                    else{
//                        [self busy];
                        [self->def setObject:@"2" forKey:@"onoff"];
                        [self->def synchronize];
                        self->status=2;
                        [self notifydriver];
                    }
                    
                }
                else if (httpResponse.statusCode==401){
                    self->check=8;
                    [self login];
                }
                else{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:TRIPNOTACC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    self->marker1.map=nil;
                    self->marker2.map=nil;
                    self->accept=0;
                    self->_view_alert.hidden=YES;
                    self->_view_subView.hidden=NO;
                    self->lbl_heading.text=[NSString stringWithFormat:@"Canadian Safe Ride"];
                    self->removeview=0;
                    NSLog(@"Error  :  %@",error);
                    [self->_loadingView removeFromSuperview];
                    [self->def setObject:@"1" forKey:@"onoff"];
                    [self->def removeObjectForKey:@"notifyrideid"];
                    [self->def synchronize];
                    [self online];
                }
            });
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
    check=9;
    def=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *driid1=[[NSMutableArray alloc]init];
    [driid1  addObject: self->userid];
    //     NSLog(@"Can Tot dri  :  %@",driid1);
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
    params = @{@"driver_id" : driid1 , @"ride_id" : [def valueForKey:@"notifyrideid"], @"title" : @"Taxi Driver", @"message" : ACCNOT, @"cab_type" : self->cabtype };
    
    
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
                [self busy];
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
                    [self busy];
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
                    [self busy];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=9;
                    [self login];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    [self busy];
                    
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                [self busy];
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
    NSLog(@"viewWillDisappear");
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.homepostLoc isValid]) {
        [appDelegate.homepostLoc invalidate];
        appDelegate.homepostLoc=nil;
    }
    else{
        [appDelegate.homepostLoc invalidate];
        appDelegate.homepostLoc=nil;
    }
name=nil;email=nil;mmble=nil;insnum=nil;licnum=nil;model=nil;pwd=nil;planum=nil;rate=nil;acc_sta=nil;pro_sta=nil;ver_sta=nil;chkstr=nil;cabtype1=nil;dricurlat=nil;dricurlon=nil;drioldlat=nil;drioldlon=nil;drinewlat=nil;drinewlon=nil;resultAddr=nil;accdriid=nil;basedist=nil;basefare=nil;cabfare=nil;cabtype=nil;bkdatetime=nil;fromlat=nil;fromlon=nil;fromloc=nil;tolat=nil;tolon=nil;toloc=nil;paysta=nil;paytype=nil;ridestatus=nil;totdist=nil;tottime=nil;userid=nil;rideid=nil;notifycabfare=nil;notifycabtype=nil;notifyfromlat=nil;notifyfromlon=nil;notifyfromloc=nil;notifytolat=nil;notifytolon=nil;notifytoloc=nil;notifypaytype=nil;notifypaysta=nil;notifyridesta=nil;notifyuserid=nil;notifytottime=nil;notifytotdist=nil;notifybasefare=nil;notifybasedist=nil;notifysuername=nil;notifysuermble=nil;notifysueremail=nil;notifysuerdeciid=nil;notifyuserating=nil;notifycreatedate=nil;notifysuerdelsta=nil;notifysueraccsta=nil;notifysuerversta=nil;notifyuserprofimg=nil;
//    [_locationManager stopUpdatingLocation];
}
//- (void)appDidBecomeActive:(NSNotification *)notification {
//    NSLog(@"did become active notification");
//}
//
//- (void)appWillEnterForeground:(NSNotification *)notification {
//    NSLog(@"will enter foreground notification");
//}
@end

