//
//  TripDetailsViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "TripDetailsViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "ASStarRatingView.h"
#import "Constant.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MyTripsViewController.h"
@import GoogleMaps;

@interface TripDetailsViewController ()<CLLocationManagerDelegate,GMSMapViewDelegate>{
    NSUserDefaults *def;
    __weak IBOutlet UIView *view_main;
    NSString *cabtype;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_hst;
@property(strong,nonatomic)IBOutlet UIScrollView *scroll;
@property(strong,nonatomic)IBOutlet UILabel *lbl_date;
@property(strong,nonatomic)IBOutlet UILabel *lbl_time;
@property(strong,nonatomic)IBOutlet UILabel *lbl_finalamt;
@property(strong,nonatomic)IBOutlet UILabel *lbl_pickup;
@property(strong,nonatomic)IBOutlet UILabel *lbl_dropoff;
@property(strong,nonatomic)IBOutlet UILabel *lbl_name;
@property(strong,nonatomic)IBOutlet UILabel *lbl_fare;
@property(strong,nonatomic)IBOutlet UILabel *lbl_discount;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property(strong,nonatomic)IBOutlet UILabel *lbl_total;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property(strong,nonatomic)IBOutlet UIImageView *img_profile;
@property (weak, nonatomic) IBOutlet UIImageView *img_line;
@property (weak, nonatomic) IBOutlet UILabel *lbl_stafare;
@property (weak, nonatomic) IBOutlet UILabel *lbl_stadisc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_starev;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_rec;
@property (weak, nonatomic) IBOutlet UILabel *lbl_statot;
@property (weak, nonatomic) IBOutlet ASStarRatingView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_stahst;
@property (weak, nonatomic) IBOutlet UILabel *lbl_staadmfa;
@property (weak, nonatomic) IBOutlet UILabel *lbl_admfa;
@property (weak, nonatomic) IBOutlet UILabel *lbl_stadrifa;
@property (weak, nonatomic) IBOutlet UIImageView *img_cancel;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_drifa;
@property (weak, nonatomic) IBOutlet UILabel *lbl_review;
@end

@implementation TripDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, view_main.frame.size.height);
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        _scroll.frame=CGRectMake(0, statusBar.frame.size.height+view_main.frame.size.height, self.view.frame.size.width, self.scroll.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//        
//    }
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    _img_profile.layer.cornerRadius = _img_profile.frame.size.width / 2;
    _img_profile.clipsToBounds = YES;
    if ([UIScreen mainScreen].bounds.size.height==568) {
        [_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height*1.8)];
    }
    else{
        [_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height*1.5)];
    }
    [self setValues];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)back_doAction:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyTripsViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"MyTripsViewController"];
    [self presentViewController:view animated:YES completion:nil];
}
-(void)setValues{
dispatch_async(dispatch_get_main_queue(), ^{
    
    self->_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self->_loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:self->_loadingView];
//    NSString *datestring=self->_time;
//    NSArray * array = [datestring componentsSeparatedByString:@" "];
//    NSString * str1 = [array objectAtIndex:0]; //123
//    NSString * str2 = [array objectAtIndex:1];
    if ([self->_disc isEqual:(id)[NSNull null]]) {
        self->_lbl_discount.text=[NSString stringWithFormat:@"CAD %@",@"0"];
    }
    else {
        self->_lbl_discount.text=[NSString stringWithFormat:@"CAD %@",self->_disc];
    }
    if ([self->_date isEqual:(id)[NSNull null]]) {
        self->_lbl_date.text=[NSString stringWithFormat:@"%@",@"----"];
    }
    else {
        self->_lbl_date.text=[NSString stringWithFormat:@"%@",self->_time];
    }
//    if ([self->_time isEqual:(id)[NSNull null]]) {
//        self->_lbl_time.text=[NSString stringWithFormat:@"%@",@"------"];
//    }
//    else{
//        self->_lbl_time.text=[NSString stringWithFormat:@"%@",str2];
//    }
    
    if ([self->_pri isEqual:(id)[NSNull null]]) {
        self->_lbl_finalamt.text=[NSString stringWithFormat:@"CAD %@",@"0"];
        self->_lbl_total.text=[NSString stringWithFormat:@"CAD %@",@"0"];
    }
    else {
        self->_lbl_finalamt.text=[NSString stringWithFormat:@"CAD %@",self->_pri];
        self->_lbl_total.text=[NSString stringWithFormat:@"CAD %@",self->_pri];
    }
    if ([self->_pickaddr isEqual:(id)[NSNull null]]) {
        self->_lbl_pickup.text=[NSString stringWithFormat:@"%@",@"-------"];
    }
    else {
        self->_lbl_pickup.text=[NSString stringWithFormat:@"%@",self->_pickaddr];
    }
    if ([self->_dropaddr isEqual:(id)[NSNull null]]) {
        self->_lbl_dropoff.text=[NSString stringWithFormat:@"%@",@"------"];
    }
    else {
        self->_lbl_dropoff.text=[NSString stringWithFormat:@"%@",self->_dropaddr];
    }
    if ([self->_driname isEqual:(id)[NSNull null]]) {
        self->_lbl_name.text=[NSString stringWithFormat:@"%@",@"------"];
    }
    else {
        self->_lbl_name.text=[NSString stringWithFormat:@"%@",self->_driname];
    }
    if ([self->_base isEqual:(id)[NSNull null]]) {
        self->_lbl_fare.text=[NSString stringWithFormat:@"CAD %@",@"0"];
    }
    else {
        self->_lbl_fare.text=[NSString stringWithFormat:@"CAD %@",self->_base];
    }
    [self->_lbl_pickup sizeToFit];
    self->_lbl_pickup.lineBreakMode = NSLineBreakByWordWrapping;
    self->_lbl_pickup.numberOfLines=2;
    [self->_lbl_pickup sizeToFit];
    
    [self->_lbl_dropoff sizeToFit];
    self->_lbl_dropoff.lineBreakMode = NSLineBreakByWordWrapping;
    self->_lbl_dropoff.numberOfLines=2;
    [self->_lbl_dropoff sizeToFit];
    
    self->_lbl_hst.text=[NSString stringWithFormat:@"CAD %@",self->_hst];
    self->_lbl_admfa.text=[NSString stringWithFormat:@"CAD %@",self->_adminfare];
    self->_lbl_drifa.text=[NSString stringWithFormat:@"CAD %@",self->_driverfare];
    NSData *imageData = [self dataFromBase64EncodedString:self->_image];
    if (imageData.length==0) {
        self.img_profile.image = [UIImage imageNamed:@"profile.png"];
    }
    else {
        
        self.img_profile.image=[UIImage imageWithData:imageData];
        
    }
    double r1=[self->_ratings doubleValue];
    self->_rateView.maxRating = 5;
    self->_rateView.canEdit = NO;
    self->_rateView.rating = r1;
    self->_lbl_review.text=[NSString stringWithFormat:@"%@",self->_review];
    [self->_lbl_review sizeToFit];
//    [self->_lbl_finalamt sizeToFit];
//    [self downloadImageAtURL:driverimage withHandler:^(UIImage *image){
//        if (image) {
//            self->_img_profile.layer.cornerRadius = self->_img_profile.frame.size.width / 2;
//            self->_img_profile.clipsToBounds = YES;
//            self->_img_profile.image = image;
//        }
//    }];
    if ([self->_ridestatus integerValue]==5 && [self->_base integerValue]==0) {
        self->_img_cancel.hidden=NO;
        self->_img_line.hidden=YES;
        self->_lbl_rec.hidden=YES;
        self->_lbl_statot.hidden=YES;
        self->_lbl_stadisc.hidden=YES;
        self->_lbl_stafare.hidden=YES;
        self->_lbl_fare.hidden=YES;
        self->_lbl_discount.hidden=YES;
        self->_lbl_total.hidden=YES;
        self->_lbl_finalamt.hidden=YES;
        self->_lbl_stahst.hidden=YES;
        self->_lbl_hst.hidden=YES;
        self->_lbl_stadrifa.hidden=YES;
        self->_lbl_drifa.hidden=YES;
        self->_img1.hidden=YES;
        self->_img2.hidden=YES;
        self->_img3.hidden=YES;
        self->_lbl_starev.hidden=YES;
        self->_lbl_staadmfa.hidden=YES;
        self->_lbl_admfa.hidden=YES;
        self->_rateView.hidden=YES;
        self->_lbl_review.hidden=YES;
    }
    else if ([self->_ridestatus integerValue]==5) {
        NSLog(@"YESSSS");
        self->_img_cancel.hidden=NO;
        self->_img_line.hidden=NO;
        self->_lbl_rec.hidden=NO;
        self->_lbl_statot.hidden=NO;
        self->_lbl_stadisc.hidden=NO;
        self->_lbl_stafare.hidden=NO;
        self->_lbl_fare.hidden=NO;
        self->_lbl_discount.hidden=NO;
        self->_lbl_total.hidden=NO;
        self->_lbl_finalamt.hidden=NO;
        self->_lbl_stahst.hidden=NO;
        self->_lbl_hst.hidden=NO;
        self->_lbl_staadmfa.hidden=NO;
        self->_lbl_admfa.hidden=NO;
        self->_lbl_stadrifa.hidden=NO;
        self->_lbl_drifa.hidden=NO;
        self->_img1.hidden=NO;
        self->_img2.hidden=NO;
        self->_lbl_review.hidden=YES;
        self->_lbl_stafare.text=[NSString stringWithFormat:@"Cancel fare"];
        self->_img3.hidden=YES;
        self->_lbl_starev.hidden=YES;
        self->_lbl_review.hidden=YES;
        self->_rateView.hidden=NO;
    }
    else{
        NSLog(@"NOOOOO");
        self->_img_cancel.hidden=YES;
        self->_img_line.hidden=NO;
        self->_lbl_rec.hidden=NO;
        self->_lbl_statot.hidden=NO;
        self->_lbl_stadisc.hidden=NO;
        self->_lbl_stafare.hidden=NO;
        self->_lbl_fare.hidden=NO;
        self->_lbl_discount.hidden=NO;
        self->_lbl_total.hidden=NO;
        self->_lbl_finalamt.hidden=NO;
        self->_lbl_stahst.hidden=NO;
        self->_lbl_hst.hidden=NO;
        self->_lbl_staadmfa.hidden=NO;
        self->_lbl_admfa.hidden=NO;
        self->_lbl_stadrifa.hidden=NO;
        self->_lbl_drifa.hidden=NO;
        self->_img1.hidden=NO;
        self->_img2.hidden=NO;
        self->_lbl_review.hidden=NO;
        self->_lbl_stafare.text=[NSString stringWithFormat:@"Base fare"];
        self->_img3.hidden=NO;
        self->_lbl_starev.hidden=NO;
        self->_lbl_review.hidden=NO;
        self->_rateView.hidden=NO;
    }
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [UIImage imageNamed:@"pick.png"];
    double lat=[self->_picklat doubleValue];
    double lon=[self->_picklon doubleValue];
    marker.position = CLLocationCoordinate2DMake(lat,lon);
    marker.title = [NSString stringWithFormat:@"%@",@"Pickup Location"];
    marker.map = self->_mapView;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:19];
    [self->_mapView animateToCameraPosition:camera];
    
    
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.icon = [UIImage imageNamed:@"drop.png"];
    if ([self->_droplat isEqual:(id)[NSNull null]] || [self->_droplon isEqual:(id)[NSNull null]]) {
        
    }
    else{
        double lat1=[self->_droplat doubleValue];
        double lon1=[self->_droplon doubleValue];
        marker1.position = CLLocationCoordinate2DMake(lat1,lon1);
        marker1.title = [NSString stringWithFormat:@"%@",@"Dropoff Location"];
        //    GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:lat1 longitude:lon1 zoom:19];
        //    [self->_mapView animateToCameraPosition:camera1];
        marker1.map = self->_mapView;
    }
    
    [self->_loadingView removeFromSuperview];
    [self profimage];
//    [self drawRoute];
//    //                                              POLYLINE
//    GMSMutablePath *path = [GMSMutablePath path];
//    [path addCoordinate:CLLocationCoordinate2DMake(self->_picklat.doubleValue,self->_picklon.doubleValue)];
//    [path addCoordinate:CLLocationCoordinate2DMake(self->_droplat.doubleValue,self->_droplon.doubleValue)];
//
//    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
//    rectangle.strokeWidth = 2.f;
//    rectangle.map = self->_mapView;
//    //self.view=mapView;
    [self->_scroll addSubview:self->_mapView];

    [self->_loadingView removeFromSuperview];
});
}
- (void)downloadImageAtURL:(NSString *)imageURL withHandler:(void(^)(UIImage *image))handler
     {
         NSLog(@"Image String  : %@",imageURL);
         
         NSString *spaceStrObj=[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         
         NSURL *urlString = [NSURL URLWithString:spaceStrObj];
         
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_async(queue, ^{
             NSError *error = nil;
             NSData *data = [NSData dataWithContentsOfURL:urlString options:NSDataReadingUncached error:&error];
             if (!error) {
                 UIImage *downloadedImage = [UIImage imageWithData:data];
                 handler(downloadedImage); // pass back the image in a block
             } else {
                 NSLog(@"%@", [error localizedDescription]);
                 handler(nil); // pass back nil in the block
             }
         });
     }
-(void)drawRoute{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_loadingView removeFromSuperview];
        NSLog(@"draw route");
        CLLocation *origin1 =  [[CLLocation alloc] initWithLatitude:self->_picklat.doubleValue longitude:self->_picklon.doubleValue];
        CLLocation *destination1 =  [[CLLocation alloc] initWithLatitude:self->_droplat.doubleValue longitude:self->_droplon.doubleValue];
        [self fetchPolylineWithOrigin:origin1 destination:destination1 completionHandler:^(GMSPolyline *polyline)
         {
             NSLog(@"if polylone");
             if(polyline){
                 polyline.map = self->_mapView;
             }
             else{
                 NSLog(@"else polylone");
                 //POLYLINE
                 //                 GMSMutablePath *path = [GMSMutablePath path];
                 //                 [path addCoordinate:CLLocationCoordinate2DMake(_picklat.doubleValue,_picklon.doubleValue)];
                 //                 [path addCoordinate:CLLocationCoordinate2DMake(_droplat.doubleValue,_droplon.doubleValue)];
                 //
                 //                 GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
                 //                 //   rectangle.strokeWidth = 2.f;
                 //                 rectangle.strokeColor=[UIColor greenColor];
                 //                 rectangle.strokeWidth = 5.f;
                 //                 rectangle.map = _mapView;
                 //                 self.view=_mapView;
                 //POLYLINE
             }
         }];
    });
}
- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSLog(@"fetch polyine");
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving&key=AIzaSyDhQlBsFXWQTcezmSPdIPyCOd1wgPcsRkE", directionsAPI, originString, destinationString];
    NSLog(@"fetch polyine api  :  %@",directionsUrlString);
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
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
                                                             polyline.strokeColor=[UIColor greenColor];
                                                             polyline.strokeWidth = 5.f;
                                                             
                                                         }
                                                         
                                                         
                                                         // run completionHandler on main thread
                                                         if(completionHandler)
                                                             completionHandler(polyline);
                                                     });
                                                 }];
    [fetchDirectionsTask resume];
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
-(void)profimage{
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@api/user/%@?userId=%@",LOGIN_URL,@"getBaseProfileImage",_userid]];
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
                if (response1 == (id)[NSNull null]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self->_img_profile.image=[UIImage imageNamed:@"profile.png"];
                    });
                }
                else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *imageData = [self dataFromBase64EncodedString:response1];
                    if (imageData.length==0) {
                        self->_img_profile.image = [UIImage imageNamed:@"profile.png"];
                    }
                    else {
                        
                        self->_img_profile.image=[UIImage imageWithData:imageData];
                        
                    }
                    
                });
                NSLog(@"Tot Resp  :  %@",response1);
            }
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self login];
                });
            }
            else{
                
            }
        }
        }
    }];
    [downloadTask resume];

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
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if(httpResponse.statusCode == 200)
        {
            self->def=[NSUserDefaults standardUserDefaults];
            NSString *cab=[responseDictionary valueForKey:@"cab_type"];
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
                self->cabtype=@"";
            }
            else{
                self->cabtype=cab;
            }
            [self->def setObject:self->cabtype forKey:@"cabtype"];
            [self->def setObject:@"1" forKey:@"UserLogin"];
            [self->def synchronize];
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error1=[returnstring boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error1==0) {
                    [self profimage];
                    
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
@end
