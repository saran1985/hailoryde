//
//  EndRideViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "EndRideViewController.h"
#import "AlertViewController.h"
#import "Constant.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "HCSStarRatingView.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface EndRideViewController ()<UITextViewDelegate,UITextFieldDelegate>{
    NSString *rate,*cabtype;
    float rateValue;
    NSUserDefaults *def;
    int check;
    __weak IBOutlet UIScrollView *scroll;
    AppDelegate *appDelegate;
}
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusname;
@property(strong,nonatomic)IBOutlet UILabel *lbl_cusmble;
@property(strong,nonatomic)IBOutlet UILabel *lbl_pick;
@property(strong,nonatomic)IBOutlet UILabel *lbl_drop;
@property(strong,nonatomic)IBOutlet UILabel *lbl_date;
@property(strong,nonatomic)IBOutlet UILabel *lbl_time;
@property(strong,nonatomic)IBOutlet UILabel *lbl_totamt;
@property(strong,nonatomic)IBOutlet UIButton *btn_finishride;
@property(strong,nonatomic)IBOutlet UIImageView *img_profile;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_paytype;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
#define MAX_LENGTH 200
@end

@implementation EndRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        scroll.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, scroll.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//        
//    }
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
   
    self.manWalkingImageView.animatedImage = manWalkingImage;
    [self->scroll setContentSize:CGSizeMake(self->scroll.frame.size.width, self->scroll.frame.size.height*1.5)];
//    _btn_finishride.layer.borderColor=
//    _btn_finishride.layer.cornerRadius=20;
    
    //    _btn_cancel.layer.borderColor=
//    _btn_cancel.layer.cornerRadius=20;
    
//    _img_profile.center = CGPointMake(_img_profile.frame.size.width/2, _img_profile.frame.size.height/2);
    _img_profile.layer.cornerRadius = _img_profile.frame.size.width / 2;
    _img_profile.clipsToBounds = YES;
    rate=@"0";
    rateValue=0.0;
    check=0;
    _txtView.textColor=[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
    _txtView.layer.borderColor=[[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.5] CGColor];
    _txtView.layer.borderWidth=2;
    //    _txt_feedback.layer.cornerRadius=10;
    _txtView.clipsToBounds=YES;
    _txtView.delegate=self;
    [self showReport];
    // Do any additional setup after loading the view.
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
-(IBAction)finishride_doAction:(id)sender{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
    [_txtView resignFirstResponder];
    [self final];
}
-(void)showReport{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->def=[NSUserDefaults standardUserDefaults];
        NSArray *listItems = [self->_date componentsSeparatedByString:@" "];
        self->_lbl_date.text=[NSString stringWithFormat:@"%@",[listItems objectAtIndex:0]];
        self->_lbl_time.text=[NSString stringWithFormat:@"%@",[listItems objectAtIndex:1]];
        self->_lbl_cusmble.text=[NSString stringWithFormat:@"%@",[self->def valueForKey:@"cusmble"]];
        self->_lbl_cusname.text=[NSString stringWithFormat:@"%@",[self->def valueForKey:@"cusname"]];
        self->_lbl_pick.text=[NSString stringWithFormat:@"%@",self->_fromloc];
        self->_lbl_drop.text=[NSString stringWithFormat:@"%@",self->_toloc];
        self->_lbl_totamt.text=[NSString stringWithFormat:@"CAD %@",self->_amt];
        if ([self->_paytype integerValue]==0) {
            self->_lbl_paytype.text=[NSString stringWithFormat:@"Payment type : Cash"];
        }
        else{
            self->_lbl_paytype.text=[NSString stringWithFormat:@"Payment type : Card"];
        }
        [self->_lbl_pick sizeToFit];
        self->_lbl_pick.lineBreakMode = NSLineBreakByWordWrapping;
        self->_lbl_pick.numberOfLines=2;
        [self->_lbl_pick sizeToFit];
        
        [self->_lbl_drop sizeToFit];
        self->_lbl_drop.lineBreakMode = NSLineBreakByWordWrapping;
        self->_lbl_drop.numberOfLines=2;
        [self->_lbl_drop sizeToFit];
        [self image];
    });
}
- (IBAction)didValueChanged:(HCSStarRatingView *)sender {
    [self.view endEditing:YES];
    rate=[NSString stringWithFormat:@"%f",sender.value];
    rateValue=[rate floatValue];
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
                    [self showReport];
                }
                else if (self->check==2){
                    [self final];
                }
                else if (self->check==3){
                    [self online];
                }
                else if (self->check==4){
                    [self image];
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
-(void)final{
    @try{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSString *comm=_txtView.text;
    NSLog(@"Http Comm  :  %@",comm);
    if ([comm isEqualToString:@"Type your comments"]||[comm isEqual:@"Type your comments"]) {
        comm=@"";
    }
    else{
        
    }
    //    NSString *rating=[NSString stringWithFormat:@"%.1f",rateValue];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"rateRide"]]];
    
    //-LMfNdTOp0-TdmL0Rr-Z
    NSDictionary *userUpdate = @{@"user_id" : [def valueForKey:@"userid"], @"delete_status" : @"string", @"rating" : rate, @"ride_id" :[def valueForKey:@"rideid"],@"driver_id" : [def valueForKey:@"driid"],@"review" : comm};
    
    //    NSDictionary *userUpdate = @{@"user_id" : [def valueForKey:@"userid"], @"delete_status" : @"string", @"rating" : rate, @"ride_id=" :@"-LMfNdTOp0-TdmL0Rr-Z"};
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:userUpdate options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    
    NSLog(@"Input  :  %@",userUpdate);
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:tot forHTTPHeaderField:@"Authorization"];
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            NSLog(@"The response is1 - %@",responseDictionary);
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error1=[returnstring boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                if (error1==0) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:RATESUC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    [self online];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"error_description"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    });
                }
            });
            
        }
        else if (httpResponse.statusCode==400){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"error_description"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"error_description"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                self->check=2;
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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
//        [def setObject:@"0" forKey:@"view"];
//        [def synchronize];
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
//        [self presentViewController:alert11 animated:YES completion:nil];
//    });
}
- (IBAction)cance_doAction:(id)sender {
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
    [_txtView resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:@"0" forKey:@"view"];
        [def synchronize];
        [self online];
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
//        [self presentViewController:alert11 animated:YES completion:nil];
    });
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
                    self->check=3;
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
//                    NSString *msg=[responseDictionary valueForKey:@"errorMessage"];
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
-(void)image{
    check=4;
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
                    NSData *imagedata = [self dataFromBase64EncodedString:response1];
                    if (imagedata.length==0) {
                        self->_img_profile.image = [UIImage imageNamed:@"profile.png"];
                    }
                    else {
                        
                        self->_img_profile.image=[UIImage imageWithData:imagedata];
                        
                    }
                    [self->_loadingView removeFromSuperview];
                    
                });
                NSLog(@"Tot Resp  :  %@",response1);
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=4;
                    [self login];
                });
            }
            else if (httpResponse.statusCode==403){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
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
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
    }
    else{
    [scroll setContentOffset:CGPointMake(0, 410) animated:YES];
    }
    if ([_txtView.text isEqualToString:@"Type your comments"] || [_txtView.text isEqual:@"Type your comments"]) {
         _txtView.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
         _txtView.text=@"";
    }
    else{
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [_txtView resignFirstResponder];
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [_txtView.text stringByReplacingCharactersInRange: range withString:text];
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if( [newText length]<= MAX_LENGTH ){
        return YES;
    }
    // case where text length > MAX_LENGTH
    textView.text = [ newText substringToIndex: MAX_LENGTH ];
    return NO;
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
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.homepostLoc isValid]) {
        [appDelegate.homepostLoc invalidate];
        appDelegate.postLoc=nil;
    }
    else{
        [appDelegate.homepostLoc invalidate];
        appDelegate.homepostLoc=nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    rate=nil;
    cabtype=nil;
}
@end
