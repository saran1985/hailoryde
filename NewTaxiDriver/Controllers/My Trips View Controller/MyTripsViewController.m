//
//  MyTripsViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MyTripsViewController.h"
#import "CustomMyTripsTableViewCell.h"
#import "TripDetailsViewController.h"
#import "Constant.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "ASStarRatingView.h"
#import "TrackViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MyAccountViewController.h"

@interface MyTripsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UIView *view_main;
@property(strong,nonatomic)IBOutlet UITableView *table;
@end

@implementation MyTripsViewController{
    NSMutableArray *date;
    NSMutableArray *time;
    NSMutableArray *carname;
    NSMutableArray *carnum;
    NSMutableArray *price;
    NSMutableArray *userratings;
    NSMutableArray *picklat;
    NSMutableArray *picklon;
    NSMutableArray *pickaddr;
    NSMutableArray *droplat;
    NSMutableArray *droplon;
    NSMutableArray *dropaddr,*hst,*basedist,*adminfare,*driverfare,*review;
    NSMutableArray *modifiedby,*modifiedcomm,*modifieddate,*paysta,*paytype,*starttime,*ridestatus,*driaccsta,*driinsnum,*drilicnum,*driplate,*drimodel,*driratings,*driverify,*rideid;
    NSMutableArray *additionalfare,*email,*mobile,*name,*password,*basefare,*cabfare,*cabtype,*createdate,*driverid,*endtime,*totaldistance,*totaltime,*username,*usermble,*usermail,*userprofimg,*userid;
    NSUserDefaults *def;
    __weak IBOutlet UILabel *lbl_network;
    NSString *cabtype1;
    NSInteger tag;
    int check;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    _view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, _view_main.frame.size.height);
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        _table.frame=CGRectMake(0, statusBar.frame.size.height+_view_main.frame.size.height, self.view.frame.size.width, self.table.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//        
//    }
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    date=[[NSMutableArray alloc]init];
    time=[[NSMutableArray alloc]init];
    carname=[[NSMutableArray alloc]init];
    carnum=[[NSMutableArray alloc]init];
    price=[[NSMutableArray alloc]init];
    userratings=[[NSMutableArray alloc]init];
    picklat=[[NSMutableArray alloc]init];
    picklon=[[NSMutableArray alloc]init];
    pickaddr=[[NSMutableArray alloc]init];
    droplat=[[NSMutableArray alloc]init];
    droplon=[[NSMutableArray alloc]init];
    dropaddr=[[NSMutableArray alloc]init];
    cabfare=[[NSMutableArray alloc]init];
    cabtype=[[NSMutableArray alloc]init];
    driverid=[[NSMutableArray alloc]init];
    endtime=[[NSMutableArray alloc]init];
    modifiedby=[[NSMutableArray alloc]init];
    modifiedcomm=[[NSMutableArray alloc]init];
    modifieddate=[[NSMutableArray alloc]init];
    paysta=[[NSMutableArray alloc]init];
    paytype=[[NSMutableArray alloc]init];
    starttime=[[NSMutableArray alloc]init];
    additionalfare=[[NSMutableArray alloc]init];
    email=[[NSMutableArray alloc]init];
    mobile=[[NSMutableArray alloc]init];
    name=[[NSMutableArray alloc]init];
    password=[[NSMutableArray alloc]init];
    basefare=[[NSMutableArray alloc]init];
    createdate=[[NSMutableArray alloc]init];
    totaldistance=[[NSMutableArray alloc]init];
    totaltime=[[NSMutableArray alloc]init];
    ridestatus=[[NSMutableArray alloc]init];
    driaccsta=[[NSMutableArray alloc]init];
    driinsnum=[[NSMutableArray alloc]init];
    drilicnum=[[NSMutableArray alloc]init];
    drimodel=[[NSMutableArray alloc]init];
    driplate=[[NSMutableArray alloc]init];
    driratings=[[NSMutableArray alloc]init];
    driverify=[[NSMutableArray alloc]init];
    username=[[NSMutableArray alloc]init];
    usermail=[[NSMutableArray alloc]init];
    usermble=[[NSMutableArray alloc]init];
    rideid=[[NSMutableArray alloc]init];
    userprofimg=[[NSMutableArray alloc]init];
    userid=[[NSMutableArray alloc]init];
    hst=[[NSMutableArray alloc]init];
    basedist=[[NSMutableArray alloc]init];
    adminfare=[[NSMutableArray alloc]init];
    driverfare=[[NSMutableArray alloc]init];
    review=[[NSMutableArray alloc]init];
    lbl_network.hidden=YES;
    _table.hidden=YES;
    [self postMethod];
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
    MyAccountViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
    [self presentViewController:view animated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return picklat.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"CustomMyTripsTableViewCell";
    CustomMyTripsTableViewCell *cell=[_table dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle=UITableViewStylePlain;
    cell.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    _table.separatorColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.5];
    // cell.samview.layer.cornerRadius=15;
//    cell.view_main.backgroundColor=[UIColor lightGrayColor];
    double r1=[[driratings objectAtIndex:indexPath.row]doubleValue];
    //    cell.view_main.layer.borderWidth=2;
    
//    cell.lbl_date.text=[NSString stringWithFormat:@"%@",[date objectAtIndex:indexPath.row]];
//    cell.lbl_name.text=[NSString stringWithFormat:@"%@",[time objectAtIndex:indexPath.row]];
    cell.staticView.maxRating = 5;
    cell.staticView.canEdit = NO;
    cell.staticView.rating = r1;
//    NSString *datestring=[createdate objectAtIndex:indexPath.row];
//    NSArray * array = [datestring componentsSeparatedByString:@" "];
//    NSString * str1 = [array objectAtIndex:0]; //123
//    NSString * str2 = [array objectAtIndex:1];
    cell.lbl_date.text=[NSString stringWithFormat:@"%@",[starttime objectAtIndex:indexPath.row]];
    cell.lbl_name.text=[NSString stringWithFormat:@"%@",[name objectAtIndex:indexPath.row]];
    cell.lbl1.text=[NSString stringWithFormat:@"%@",[pickaddr objectAtIndex:indexPath.row]];
    cell.lbl2.text=[NSString stringWithFormat:@"%@",[dropaddr objectAtIndex:indexPath.row]];
    cell.lbl_amt.text=[NSString stringWithFormat:@"CAD %@",[cabfare objectAtIndex:indexPath.row]];
    [cell.lbl_amt sizeToFit];
//    cell.img_profile.layer.cornerRadius = cell.img_profile.frame.size.width / 2;
//    cell.img_profile.clipsToBounds = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSData *imageData = [self dataFromBase64EncodedString:[self->userprofimg objectAtIndex:indexPath.row]];
//        NSLog(@"Cell for row : %@",imageData);
//        if (imageData.length==0) {
//            cell.img_profile.image = [UIImage imageNamed:@"profile.png"];
//        }
//        else {
//
//            cell.img_profile.image=[UIImage imageWithData:imageData];
//
//        }
//
//    });
    cell.img_profile.hidden=YES;
    long ridest=[[ridestatus objectAtIndex:indexPath.row]integerValue];
    if (ridest==5) {
        cell.img_icon.hidden=NO;
        cell.lbl_amt.hidden=YES;
        cell.staticView.hidden=YES;
        cell.lbl_schedule.hidden=YES;
    }
    else if(ridest==4){
        cell.img_icon.hidden=YES;
        cell.lbl_amt.hidden=NO;
        cell.staticView.hidden=NO;
        cell.lbl_schedule.hidden=YES;
    }
    else{
        cell.img_icon.hidden=YES;
        cell.lbl_amt.hidden=YES;
        cell.staticView.hidden=YES;
        cell.lbl_schedule.hidden=NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    def=[NSUserDefaults standardUserDefaults];
    tag=indexPath.row;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[self->ridestatus objectAtIndex:indexPath.row] integerValue]==4 ||[[self->ridestatus objectAtIndex:indexPath.row] integerValue]==5) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TripDetailsViewController *test = [storyboard instantiateViewControllerWithIdentifier:@"TripDetailsViewController"];
        test.date=[self->starttime objectAtIndex:indexPath.row];
        test.time=[self->starttime objectAtIndex:indexPath.row];
        test.carna=[self->cabtype objectAtIndex:indexPath.row];
        test.picklat=[self->picklat objectAtIndex:indexPath.row];
        test.picklon=[self->picklon objectAtIndex:indexPath.row];
        test.pickaddr=[self->pickaddr objectAtIndex:indexPath.row];
        test.droplat=[self->droplat objectAtIndex:indexPath.row];
        test.droplon=[self->droplon objectAtIndex:indexPath.row];
        test.dropaddr=[self->dropaddr objectAtIndex:indexPath.row];
        test.carnu=[self->cabtype objectAtIndex:indexPath.row];
        test.pri=[self->cabfare objectAtIndex:indexPath.row];
        test.driname=[self->name objectAtIndex:indexPath.row];
        test.base=[self->basefare objectAtIndex:indexPath.row];
        test.disc=[self->additionalfare objectAtIndex:indexPath.row];
        test.ridestatus=[self->ridestatus objectAtIndex:indexPath.row];
        test.ratings=[self->driratings objectAtIndex:indexPath.row];
        test.image=[self->userprofimg objectAtIndex:indexPath.row];
        test.userid=[self->userid objectAtIndex:indexPath.row];
        test.hst=[self->hst objectAtIndex:indexPath.row];
        test.review=[self->review objectAtIndex:indexPath.row];
        test.adminfare=[self->adminfare objectAtIndex:indexPath.row];
        test.driverfare=[self->driverfare objectAtIndex:indexPath.row];
        NSLog(@"Admin fare  :  %@",[self->adminfare objectAtIndex:indexPath.row]);
        NSLog(@"Driver fare  :  %@",[self->driverfare objectAtIndex:indexPath.row]);
        NSLog(@"Drop Loc  :  %@",[self->dropaddr objectAtIndex:indexPath.row]);
        [self presentViewController:test animated:YES completion:nil];
        }
        else{
            if ([[self->def valueForKey:@"onoff"] isEqualToString:@"1"] || [[self->def valueForKey:@"onoff"] isEqual:@"1"]) {
                [self busy];
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Go Online",@"Cancel", nil];
                alert.tag=1;
                [alert show];
            }
        }
    });
}
-(void)postMethod{
    check=1;
_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"getTripHistory",[def valueForKey:@"driid"]]];
//    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"getTripHistory",@"-LKeH7S-FZ8N5F87eruh"]];
    NSLog(@"Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
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
            
            // id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (data==nil || httpResponse.statusCode==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            
            else if (httpResponse.statusCode==200) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSLog(@"Json Resp  :  %@",responseDictionary);
                NSString *returnstring=[responseDictionary valueForKey:@"isError"];
                BOOL error=[returnstring boolValue];
                NSLog(@"Json1  :  %d",error);
                
               
                if (error==0 || error==false) {
                    NSArray *response=[responseDictionary valueForKeyPath:@"response.rideUserDetails"];
                    
                    NSLog(@"Json1  :  %@",response);
                    NSLog(@"Json2  :  %lu",(unsigned long)response.count);
                    if (response == (id)[NSNull null] || response.count == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self->lbl_network.hidden=NO;
                            self->_table.hidden=YES;
                            [self->_loadingView removeFromSuperview];
                        });

                        //                 if (response == nil){
                        
                    }else {
                        for (int i=response.count-1; i>=0; i--) {
                            NSString *cafa=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.cab_fare"]objectAtIndex:i];
                            if (cafa == (id)[NSNull null]){
                                [self->cabfare addObject:@""];
                            }
                            else{
                                [self->cabfare addObject:cafa];
                            }
                            NSString *cana=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails"]objectAtIndex:i];
                            if (cana == (id)[NSNull null]){
                                [self->carname addObject:@""];
                            }
                            else{
                                [self->carname addObject:cana];
                            }
                            NSString *caty=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.cab_type"]objectAtIndex:i];
                            [self->cabtype addObject:caty];
                            NSString *drid=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverRating.driver_id"]objectAtIndex:i];
                            if (drid == (id)[NSNull null]){
                                [self->driverid addObject:@""];
                            }
                            else{
                                [self->driverid addObject:drid];
                            }
                            NSString *enti=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.end_time"]objectAtIndex:i];
                            if (enti == (id)[NSNull null]){
                                [self->endtime addObject:@""];
                            }
                            else{
                                [self->endtime addObject:enti];
                            }
                            NSString *pilat=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.frm_lat"]objectAtIndex:i];
                            [self->picklat addObject:pilat];
                            NSString *pilon=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.frm_lng"]objectAtIndex:i];
                            [self->picklon addObject:pilon];
                            NSString *moby=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.modified_by"]objectAtIndex:i];
                            [self->modifiedby addObject:moby];
                            NSString *moco=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.modified_comments"]objectAtIndex:i];
                            [self->modifiedcomm addObject:moco];
                            NSString *moda=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.modified_date_time"]objectAtIndex:i];
                            [self->modifieddate addObject:moda];
                            NSString *past=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.payment_status"]objectAtIndex:i];
                            if (past == (id)[NSNull null] || past.length == 0){
                                [self->paysta addObject:@""];
                            }
                            else{
                                [self->paysta addObject:past];
                            }
                            NSString *paty=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.payment_type"]objectAtIndex:i];
                            [self->paytype addObject:paty];
                            NSString *rist=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.ride_status"]objectAtIndex:i];
                            [self->ridestatus addObject:rist];
                            NSString *stti=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.start_time"]objectAtIndex:i];
                            if (stti == (id)[NSNull null] || stti.length == 0){
                                [self->starttime addObject:@""];
                            }
                            else{
                                [self->starttime addObject:stti];
                            }
                            NSString *hs=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.hst"]objectAtIndex:i];
                            if (hs == (id)[NSNull null]){
                                [self->hst addObject:@"0"];
                            }
                            else{
                                [self->hst addObject:hs];
                            }
                            NSString *tolat=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.to_lat"]objectAtIndex:i];
                            [self->droplat addObject:tolat];
                            NSString *tolon=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.to_lng"]objectAtIndex:i];
                            [self->droplon addObject:tolon];
                            NSString *add=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.additional_fare"]objectAtIndex:i];
                            [self->additionalfare addObject:add];
                            NSString *em=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverDetails.email"]objectAtIndex:i];
                            [self->email addObject:em];
                            NSString *mo=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverDetails.mobile"]objectAtIndex:i];
                            [self->mobile addObject:mo];
                            NSString *na=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.userDetails.name"]objectAtIndex:i];
                            [self->name addObject:na];
                            NSString *pwd=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverDetails.password"]objectAtIndex:i];
                            [self->password addObject:pwd];
                            NSString *from=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.from_location"]objectAtIndex:i];
                            if (from == (id)[NSNull null]){
                                [self->pickaddr addObject:@"--------"];
                            }
                            else{
                                [self->pickaddr addObject:from];
                            }
                            NSString *to=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.to_location"]objectAtIndex:i];
                            if (to == (id)[NSNull null]){
                                [self->dropaddr addObject:@"--------"];
                            }
                            else{
                                [self->dropaddr addObject:to];
                            }
                            NSString *bafa=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.base_fare"]objectAtIndex:i];
                            [self->basefare addObject:bafa];
                            NSString *badi=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.base_dist"]objectAtIndex:i];
                            if (badi == (id)[NSNull null]){
                                [self->basedist addObject:@"0"];
                            }
                            else{
                                [self->basedist addObject:badi];
                            }
                            NSString *crda=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.created_date_time"]objectAtIndex:i];
                            [self->createdate addObject:crda];
                            NSString *todis=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.total_distance"]objectAtIndex:i];
                            [self->totaldistance addObject:todis];
                            NSString *rate=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.userDetails.rating"]objectAtIndex:i];
                            if (rate == (id)[NSNull null]){
                                [self->userratings addObject:@""];
                            }
                            else{
                                [self->userratings addObject:rate];
                            }
                            NSString *drac=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails.account_status"]objectAtIndex:i];
                            if (drac == (id)[NSNull null]){
                                [self->driaccsta addObject:@""];
                            }
                            else{
                                [self->driaccsta addObject:drac];
                            }
                            NSString *drin=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails.insurance_number"]objectAtIndex:i];
                            if (drin == (id)[NSNull null]){
                                [self->driinsnum addObject:@""];
                            }
                            else{
                                [self->driinsnum addObject:drin];
                            }
                            NSString *drli=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails.license_number"]objectAtIndex:i];
                            if (drli == (id)[NSNull null]){
                                [self->drilicnum addObject:@""];
                            }
                            else{
                                [self->drilicnum addObject:drli];
                            }
                            NSString *drmo=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails.model"]objectAtIndex:i];
                            if (drmo == (id)[NSNull null]){
                                [self->drimodel addObject:@""];
                            }
                            else{
                                [self->drimodel addObject:drmo];
                            }
                            NSString *drpl=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails.plate_number"]objectAtIndex:i];
                            if (drpl == (id)[NSNull null]){
                                [self->driplate addObject:@""];
                            }
                            else{
                                [self->driplate addObject:drpl];
                            }
                            NSString *drra=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverRating.rating"]objectAtIndex:i];
                            if (drra == (id)[NSNull null]){
                                [self->driratings addObject:@""];
                            }
                            else{
                                [self->driratings addObject:drra];
                            }
                            NSString *drve=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.cabDetails.verify_status"]objectAtIndex:i];
                            if (drve == (id)[NSNull null]){
                                [self->driverify addObject:@""];
                            }
                            else{
                                [self->driverify addObject:drve];
                            }
                            NSString *drre=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverRating.review"]objectAtIndex:i];
                            if (drre == (id)[NSNull null]){
                                [self->review addObject:@""];
                            }
                            else{
                                [self->review addObject:drre];
                            }
                            NSString *toti=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.total_time"]objectAtIndex:i];
                            [self->totaltime addObject:toti];
                            NSString *usena=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.userDetails.name"]objectAtIndex:i];
                            [self->username addObject:usena];
                            NSString *usemb=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.userDetails.mobile"]objectAtIndex:i];
                            [self->usermble addObject:usemb];
                            NSString *useem=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.userDetails.email"]objectAtIndex:i];
                            [self->usermail addObject:useem];
                            NSString *ride=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.ride_id"]objectAtIndex:i];
                            NSString *usim=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.userDetails.profile_image"]objectAtIndex:i];
                            [self->userprofimg addObject:usim];
                            NSString *usiid=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.user_id"]objectAtIndex:i];
                            [self->userid addObject:usiid];
                            if (ride == (id)[NSNull null]|| ride.length == 0){
                                [self->rideid addObject:@""];
                            }
                            else {
                                [self->rideid addObject:ride];
                            }
                            NSString *adfa=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.admin_fare"]objectAtIndex:i];
                            NSLog(@"admin fare did select  :  %@",adfa);
                            if (adfa == (id)[NSNull null]){
                                [self->adminfare addObject:@"0.0"];
                            }
                            else{
                                [self->adminfare addObject:adfa];
                            }
                            NSString *drfa=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.rideDetails.driver_fare"]objectAtIndex:i];
                            NSLog(@"Driver fare did select  :  %@",drfa);
                            if (drfa == (id)[NSNull null]){
                                [self->driverfare addObject:@"0.0"];
                            }
                            else{
                                [self->driverfare addObject:drfa];
                            }
//                            NSString *profimg=[[responseDictionary valueForKeyPath:@"response.rideUserDetails.driverDetails.profile_image"]objectAtIndex:i];
//                            if (profimg == (id)[NSNull null] || profimg.length==0){
//                                [self->userprofimg addObject:@""];
//                            }
//                            else{
//                                [self->userprofimg addObject:profimg];
//                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self->lbl_network.hidden=YES;
                            self->_table.hidden=NO;
                            [self->_table reloadData];
                            [self->_loadingView removeFromSuperview];
                        });
                    }
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self->_loadingView removeFromSuperview];
                   
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                         });
                }
                
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=1;
                    [self->_loadingView removeFromSuperview];
                    [self login];
                });
            }
            else if (httpResponse.statusCode==400){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
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
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 162.0;
    return 129.0;
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
                self->cabtype1=@"";
            }
            else{
                self->cabtype1=cab;
            }
            [self->def setObject:self->cabtype1 forKey:@"cabtype"];
            [self->def setObject:@"1" forKey:@"UserLogin"];
            [self->def synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                if (self->check==1) {
                    [self postMethod];
                }
                else if (self->check==2){
                    [self busy];
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
-(void)busy{
        check=2;
        _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
        _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.loadingView.alpha=0.7;
        [self.view addSubview:_loadingView];
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
                            [self->def setObject:[self->rideid objectAtIndex:self->tag] forKey:@"rideid"];
                            [self->def setObject:[self->userid objectAtIndex:self->tag] forKey:@"userid"];
                            [self->def setObject:[self->rideid objectAtIndex:self->tag] forKey:@"notifyrideid"];
                            [self->def synchronize];
                            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            TrackViewController *track = [storyboard instantiateViewControllerWithIdentifier:@"TrackViewController"];
                            track.rideid=[self->rideid objectAtIndex:self->tag];
                            track.basedist=[self->basedist objectAtIndex:self->tag];
                            track.basefare=[self->basefare objectAtIndex:self->tag];
                            track.cabfare=[self->cabfare objectAtIndex:self->tag];
                            track.cabtype=[self->cabtype objectAtIndex:self->tag];
                            track.bkdatetime=[self->starttime objectAtIndex:self->tag];
                            track.fromlat=[self->picklat objectAtIndex:self->tag];
                            track.fromlon=[self->picklon objectAtIndex:self->tag];
                            track.fromloc=[self->pickaddr objectAtIndex:self->tag];
                            track.tolat=[self->droplat objectAtIndex:self->tag];
                            track.tolon=[self->droplon objectAtIndex:self->tag];
                            track.toloc=[self->dropaddr objectAtIndex:self->tag];
                            track.paysta=[self->paysta objectAtIndex:self->tag];
                            track.paytype=[self->paytype objectAtIndex:self->tag];
                            track.ridestatus=[self->ridestatus objectAtIndex:self->tag];
                            track.totdist=[self->totaldistance objectAtIndex:self->tag];
                            track.tottime=[self->totaltime objectAtIndex:self->tag];
                            track.userid=[self->userid objectAtIndex:self->tag];
                            track.cusname=[self->username objectAtIndex:self->tag];
                            track.cusmble=[self->usermble objectAtIndex:self->tag];
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
                        [self->_loadingView removeFromSuperview];
                    });
                }
                else if (httpResponse.statusCode==401){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->check=2;
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
//                        NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
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
    }
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1)
    {
        if (buttonIndex==0) {
            [self busy];
        }
        else{
            
        }
    }
    else{
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    cabtype1=nil;
    date=nil;
    [date removeAllObjects];
    time=nil;
    [time removeAllObjects];
    carnum=nil;
    [carnum removeAllObjects];
    carname=nil;
    [carname removeAllObjects];
    price=nil;
    [price removeAllObjects];
    userratings=nil;
    [userratings removeAllObjects];
    picklat=nil;
    [picklat removeAllObjects];
    picklon=nil;
    [picklon removeAllObjects];
    pickaddr=nil;
    [pickaddr removeAllObjects];
    droplat=nil;
    [droplat removeAllObjects];
    droplon=nil;
    [droplon removeAllObjects];
    dropaddr=nil;
    [dropaddr removeAllObjects];
    hst=nil;basedist=nil;adminfare=nil;driverfare=nil;review=nil;modifiedby=nil;modifiedcomm=nil;modifieddate=nil;paysta=nil;paytype=nil;starttime=nil;ridestatus=nil;driaccsta=nil;driinsnum=nil;drilicnum=nil;driplate=nil;drimodel=nil;driratings=nil;driverify=nil;rideid=nil;additionalfare=nil;email=nil;mobile=nil;name=nil;password=nil;basefare=nil;cabfare=nil;cabtype=nil;createdate=nil;driverid=nil;endtime=nil;totaldistance=nil;totaltime=nil;username=nil;usermble=nil;usermail=nil;userprofimg=nil;userid=nil;
    [hst removeAllObjects];[basedist removeAllObjects];[adminfare removeAllObjects];[driverfare removeAllObjects];[review removeAllObjects];[modifiedby removeAllObjects];[modifiedcomm removeAllObjects];[modifieddate removeAllObjects];[paysta removeAllObjects];[paytype removeAllObjects];[starttime removeAllObjects];[ridestatus removeAllObjects];[driaccsta removeAllObjects];[driinsnum removeAllObjects];[drilicnum removeAllObjects];[driplate removeAllObjects];[drimodel removeAllObjects];[driratings removeAllObjects];[driverify removeAllObjects];[rideid removeAllObjects];[additionalfare removeAllObjects];[email removeAllObjects];[mobile removeAllObjects];[name removeAllObjects];[password removeAllObjects];[basefare removeAllObjects];[cabfare removeAllObjects];[cabtype removeAllObjects];[createdate removeAllObjects];[driverid removeAllObjects];[endtime removeAllObjects];[totaldistance removeAllObjects];[totaltime removeAllObjects];[username removeAllObjects];[usermble removeAllObjects];[usermail removeAllObjects];[userprofimg removeAllObjects];[userid removeAllObjects];
}
@end
