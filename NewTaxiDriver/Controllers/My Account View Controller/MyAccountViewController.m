//
//  MyAccountViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyTripsViewController.h"
#import "WorkingHoursViewController.h"
#import "ReportsViewController.h"
#import "ProfileViewController.h"
#import "AlertViewController.h"
#import  "ReportIssueViewController.h"
#import "FrontViewController.h"
#import "Constant.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface MyAccountViewController ()<UIAlertViewDelegate>{
    NSUserDefaults *def;
    __weak IBOutlet UIView *view_main;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
    @property (strong, nonatomic) IBOutlet UIView *loadingView;
    @property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
    
@end

@implementation MyAccountViewController

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
    AlertViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}
-(IBAction)mytrip_doActipn:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyTripsViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"MyTripsViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}
-(IBAction)hoursworked_doActipn:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WorkingHoursViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"WorkingHoursViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}
- (IBAction)logout_doAction:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Logout" message:@"Do you want to log out?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil];
    alert.delegate=self;
    alert.tag=1;
    [alert show];
}
-(IBAction)review_doActipn:(id)sender{
    
}
-(IBAction)reports_doActipn:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReportsViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"ReportsViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}
-(IBAction)help_doActipn:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReportIssueViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"ReportIssueViewController"];
    [self presentViewController:view animated:YES completion:nil];
}
-(IBAction)settings_doActipn:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1 && buttonIndex==1){
        [self offline];
       
    }
    else{
        
    }
}
    -(void)offline{
        _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
        _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.loadingView.alpha=0.7;
        [self.view addSubview:_loadingView];
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
                if (data==nil || httpResponse.statusCode==0) {
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
                            [self->def setObject:@"0" forKey:@"onoff"];
                            [self->def synchronize];
                            self->def=[NSUserDefaults standardUserDefaults];
                            [self->def removeObjectForKey:@"acc_tok"];
                            [self->def removeObjectForKey:@"email"];
                            [self->def removeObjectForKey:@"exp_in"];
                            [self->def removeObjectForKey:@"ins"];
                            [self->def removeObjectForKey:@"lic"];
                            [self->def removeObjectForKey:@"mobile"];
                            [self->def removeObjectForKey:@"model"];
                            [self->def removeObjectForKey:@"name"];
                            [self->def removeObjectForKey:@"driid"];
                            [self->def removeObjectForKey:@"tok_type"];
                            [self->def removeObjectForKey:@"plat"];
                            [self->def removeObjectForKey:@"newprofile"];
                            [self->def setObject:@"0" forKey:@"UserLogin"];
                            [self->def removeObjectForKey:@"onoff"];
                            [self->def synchronize];
                            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            FrontViewController *front = [storyboard instantiateViewControllerWithIdentifier:@"FrontViewController"];
                            [self presentViewController:front animated:YES completion:nil];
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
                    //            self->appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    //            self->appDelegate.homepostLoc=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(postLocationStatus)userInfo:nil repeats:YES];
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
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if(httpResponse.statusCode == 200)
            {
                NSString *cabtype1;
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
                    cabtype1=@"";
                }
                else{
                    cabtype1=cab;
                }
                [self->def setObject:cabtype1 forKey:@"cabtype"];
                [self->def setObject:@"1" forKey:@"UserLogin"];
                [self->def synchronize];
                NSString *returnstring=[responseDictionary valueForKey:@"isError"];
                BOOL error1=[returnstring boolValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error1==0) {
                        //                    UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully register to driver" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        //                    [alert1 show];
                        [self offline];
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
