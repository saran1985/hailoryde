//
//  WorkingHoursViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "WorkingHoursViewController.h"
#import "Constant.h"
#import "CommonReportViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface WorkingHoursViewController (){
    NSUserDefaults *def;
    NSString *selectVal,*startDate,*endDate,*select,*cabtype;
    int check;
    NSDateFormatter *dateFormatter;
    int val;
    __weak IBOutlet UILabel *lbl_date;
    __weak IBOutlet UIView *view_main;
    NSDate *date1,*date2;
}
@property(strong,nonatomic)IBOutlet UIButton *btn_today;
@property(strong,nonatomic)IBOutlet UIButton *btn_week;
@property(strong,nonatomic)IBOutlet UIButton *btn_startdate;
@property(strong,nonatomic)IBOutlet UIButton *btn_enddate;
@property(strong,nonatomic)IBOutlet UILabel *lbl_today;
@property(strong,nonatomic)IBOutlet UILabel *lbl_week;
@property(strong,nonatomic)IBOutlet UILabel *lbl_startdate;
@property(strong,nonatomic)IBOutlet UILabel *lbl_enddate;
@property(strong,nonatomic)IBOutlet UIButton *btn_proceed;
@property (weak, nonatomic) IBOutlet UIView *view_datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_ok;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;


@end

@implementation WorkingHoursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, view_main.frame.size.height);
//    
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
//    _btn_proceed.layer.cornerRadius=20;
//    _btn_ok.layer.cornerRadius=20;
//    _btn_cancel.layer.cornerRadius=20;
//    _btn_proceed.layer.borderColor=
    selectVal=@"";
    select=@"";
    startDate=@"";
    endDate=@"";
    check=0;
    _btn_startdate.hidden=YES;
    _btn_enddate.hidden=YES;
    _lbl_startdate.hidden=YES;
    _lbl_enddate.hidden=YES;
    lbl_date.hidden=YES;
    [_btn_week setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [_btn_today setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [_date setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forKey:@"textColor"];
//    _view_datePicker.layer.cornerRadius=10;
    _view_datePicker.clipsToBounds=YES; _view_datePicker.layer.borderColor=[UIColor colorWithRed:102.0/255.0                                 green:102.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
    _view_datePicker.layer.borderWidth=2;
    val=0;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)proceed_doAction:(id)sender{
    NSComparisonResult *result;
    NSComparisonResult *resultsta;
    NSComparisonResult *resultend;
    result=[date1 compare:date2];
    resultsta=[date1 compare:NSDate.date];
    resultend=[date2 compare:NSDate.date];
    NSLog(@"Date1 : %@",date1);
    NSLog(@"Date2: %@",date2);
    if (startDate.length==0 && endDate.length==0 && ([selectVal isEqualToString:@""] || [selectVal isEqual:@""])&& ([select isEqualToString:@""] || [select isEqual:@""])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELOPT delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([selectVal isEqualToString:@"today"] || [selectVal isEqual:@"today"]){
        [self today];
    }
//    else if ([selectVal isEqualToString:@"week"] || [selectVal isEqual:@"week"]){
//        [self today];
//    }
    else if (([startDate isEqualToString:@""]|| [startDate isEqual:@""]) && ([endDate isEqualToString:@""]|| [endDate isEqual:@""]) && ([select isEqualToString:@"week"] || [select isEqual:@"week"])){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELSTAEND delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ((([startDate isEqualToString:@"start"] && [endDate isEqualToString:@""]) || ([startDate isEqual:@"start"] && [endDate isEqual:@""])) && ([select isEqualToString:@"week"] || [select isEqual:@"week"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELEND delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ((([endDate isEqualToString:@"end"] && [startDate isEqualToString:@""]) || ([endDate isEqual:@"end"] && [startDate isEqual:@""])) && ([select isEqualToString:@"week"] || [select isEqual:@"week"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELSTA delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if(resultsta==NSOrderedDescending){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:STAGRE delegate:self cancelButtonTitle:OKBUT otherButtonTitles:nil];
        [alert show];
    }
    else if(resultend==NSOrderedDescending){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:ENDGRE delegate:self cancelButtonTitle:OKBUT otherButtonTitles:nil];
        [alert show];
    }
    else if(result==NSOrderedDescending){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELCRCTDATE delegate:self cancelButtonTitle:OKBUT otherButtonTitles:nil];
        [alert show];
    }
    else if (result==NSOrderedSame){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SAMEDATE delegate:self cancelButtonTitle:OKBUT otherButtonTitles:nil];
        [alert show];
    }
    else if ((([startDate isEqualToString:@"start"]|| [startDate isEqual:@"start"]) && ([endDate isEqualToString:@"end"]|| [endDate isEqual:@"end"])) && ([select isEqualToString:@"week"] || [select isEqual:@"week"])){
        [self dateReport];
    }
    
}
-(IBAction)enddate_doAction:(id)sender{
    [_btn_week setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_btn_today setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    check=2;
    endDate=@"end";
    select=@"week";
//    _date.minimumDate=[NSDate date];
    dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    _view_datePicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:_view_datePicker];
}
-(IBAction)startdate_doAction:(id)sender{
    [_btn_week setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_btn_today setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    check=1;
    startDate=@"start";
    select=@"week";
//    _date.minimumDate=[NSDate date];
    dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    _view_datePicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:_view_datePicker];
}
-(IBAction)week_doAction:(id)sender{
    startDate=@"";
    endDate=@"";
    selectVal=@"";
    select=@"week";
    _lbl_startdate.text=[NSString stringWithFormat:@"Start date"];
    _lbl_enddate.text=[NSString stringWithFormat:@"End date"];
    _btn_startdate.hidden=NO;
    _btn_enddate.hidden=NO;
    _lbl_startdate.hidden=NO;
    _lbl_enddate.hidden=NO;
    lbl_date.hidden=NO;
    [_btn_week setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_btn_today setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    
}
-(IBAction)today_doAction:(id)sender{
    startDate=@"";
    endDate=@"";
    select=@"";
    selectVal=@"today";
    _btn_startdate.hidden=YES;
    _btn_enddate.hidden=YES;
    _lbl_startdate.hidden=YES;
    _lbl_enddate.hidden=YES;
    lbl_date.hidden=YES;
    [_view_datePicker removeFromSuperview];
    [_btn_week setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [_btn_today setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    
}
-(void)today{
    val=1;
_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"getTodayDriverReport",[def valueForKey:@"driid"]]];
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
            NSLog(@"Http Resp Dict :  %@",responseDictionary);
            // NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            
            // NSLog(@"Json2  :  %@",returnstring);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CommonReportViewController *common = [storyboard instantiateViewControllerWithIdentifier:@"CommonReportViewController"];
                common.heading=@"Today Report";
                common.trip=[responseDictionary valueForKey:@"totalTrip"];
                common.hour=[responseDictionary valueForKey:@"hoursWorked"];
                common.amount=[responseDictionary valueForKey:@"moneyEarned"];
                NSLog(@"Val : %@",[responseDictionary valueForKey:@"moneyEarned"]);
                [self presentViewController:common animated:YES completion:nil];
            });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    [self login];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"Http Resp Dict today  :  %@",responseDictionary);
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
    [downloadTask resume];
    
}
- (IBAction)cancel_doAction:(id)sender {
    check=0;
    [_view_datePicker removeFromSuperview];
}
- (IBAction)ok_doAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self->_btn_week setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
//        [self->_btn_today setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        self->selectVal=@"";
        [self->_view_datePicker removeFromSuperview];
        if (self->check==1) {
            NSLog(@"Curre  :  %@",[self->dateFormatter stringFromDate:self->_date.date]);
            self->_lbl_startdate.text=[NSString stringWithFormat:@"%@",[self->dateFormatter stringFromDate:self->_date.date]];
            NSString *formattedDateString = [self->dateFormatter stringFromDate:self->_date.date];
            self->date1=[self->dateFormatter dateFromString:formattedDateString];
            NSLog(@"DATEEE  :  %@",[formattedDateString stringByReplacingOccurrencesOfString:@"'" withString:@" "]);
        }
        else if (self->check==2){
            self->_lbl_enddate.text=[NSString stringWithFormat:@"%@",[self->dateFormatter stringFromDate:self->_date.date]];
            NSString *formattedDateString = [self->dateFormatter stringFromDate:self->_date.date];
            self->date2=[self->dateFormatter dateFromString:formattedDateString];
            NSLog(@"DATEEE  :  %@",[formattedDateString stringByReplacingOccurrencesOfString:@"'" withString:@" "]);
        }
        else{
        
        }
    });
    
}
-(void)dateReport{
    val=2;
_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def = [NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSString *fr=_lbl_startdate.text;
    NSString *to=_lbl_enddate.text;
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@&from=%@&to=%@",BASE_URL,@"getDriverRprtBtwnDt",[def valueForKey:@"driid"],fr,to]];
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
            NSLog(@"Http Resp Dict :  %@",responseDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CommonReportViewController *common = [storyboard instantiateViewControllerWithIdentifier:@"CommonReportViewController"];
                common.heading=@"Reports Between Date";
                common.trip=[responseDictionary valueForKey:@"totalTrip"];
                common.hour=[responseDictionary valueForKey:@"hoursWorked"];
                common.amount=[responseDictionary valueForKey:@"moneyEarned"];
                [self presentViewController:common animated:YES completion:nil];
            });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    [self login];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"Http Resp Dict date  :  %@",responseDictionary);
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        if (httpResponse.statusCode==0||data==nil){
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
                if (self->val==1) {
                    [self today];
                }
                else if (self->val==2){
                    [self dateReport];
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
    }];
    [dataTask resume];
}
@end
