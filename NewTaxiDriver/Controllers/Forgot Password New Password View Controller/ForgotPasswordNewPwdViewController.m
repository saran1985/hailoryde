//
//  ForgotPasswordNewPwdViewController.m
//  Tibs-Taxi-Customer
//
//  Created by Admin on 24/09/18.
//  Copyright © 2018 BLYNC. All rights reserved.
//

#import "ForgotPasswordNewPwdViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "Constant.h"
#import "LoginViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ForgotPasswordNewPwdViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSUserDefaults *def;
    __weak IBOutlet UIView *view_main;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPwd;
@property (weak, nonatomic) IBOutlet UITextField *txt_reenterPwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_reset;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;

@end

@implementation ForgotPasswordNewPwdViewController

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
    _txt_newPwd.delegate=self;
    _txt_reenterPwd.delegate=self;
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    single.delegate=self;
    single.numberOfTapsRequired=1;
    single.numberOfTouchesRequired=1;
    //    single.numberOfTapsRequired=2;
    //    single.numberOfTouchesRequired=2;
    [_scroll addGestureRecognizer:single];
//    _btn_reset.layer.cornerRadius=20;
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
- (IBAction)back_doAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)reset_doAction:(id)sender {
    [self.view endEditing:YES];
    if ([_txt_newPwd.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NEWPWDVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (_txt_newPwd.text.length<6){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NEWPWDRANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_reenterPwd.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:REPWDVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (_txt_reenterPwd.text.length<6){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:REENTPWDRANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (![_txt_newPwd.text isEqual:_txt_reenterPwd.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PWDMISMATCH delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        [self postmethod];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
-(void)resign{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)postmethod{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"forgotPassword"]]];
    NSLog(@"Url Req  :  %@",urlRequest);
    
    NSDictionary *params = @{@"mobile" : [def valueForKey:@"mobile"], @"password" : _txt_newPwd.text};
    
    //                             };
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"name=%@&password=%@&email=%@&mobile=%@&user_type=%@",_txt_name.text,_txt_pwd.text,_txt_mail.text,_txt_mble.text,@"2"];
    NSLog(@"User Update  :  %@",jsonInputString);
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
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
        if(!error){
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
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LoginViewController *booking = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self presentViewController:booking animated:YES completion:nil];
                    
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
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSLog(@"Error  :  %@",error);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
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
    
}
-(void)login{
_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
_loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
self.loadingView.alpha=0.7;
[self.view addSubview:_loadingView];
def=[NSUserDefaults standardUserDefaults];
NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@&mobile=%@",BASE_URL,@"verifyUser",@"",_mble]];
NSLog(@"Http Url  :  %@",url2);
NSURLSession *session = [NSURLSession sharedSession];

NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];

[request setHTTPMethod:@"POST"];


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
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"Http Resp  :  %@",httpResponse);
    NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
    if(!error){
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
        NSString *returnstring=[responseDictionary valueForKey:@"isError"];
        BOOL error=[returnstring boolValue];
        if (error==0 || error==false) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                //                [self postMethod];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *booking = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self presentViewController:booking animated:YES completion:nil];
                
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"The response dict is 500- %@",responseDictionary);
                NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"The response is 500- %@",returnstring);
            });
        }
    }
    else if (httpResponse.statusCode==403){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_loadingView removeFromSuperview];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Maximum trials exceeded" message:@"Sorry! You have exceeded the maxi trials on OTP. Please request for a new OTP and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
            [alert show];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_loadingView removeFromSuperview];
            NSLog(@"Error  :  %@",error);
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"The response dict is 500- %@",responseDictionary);
            NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"The response is 500- %@",returnstring);
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
[downloadTask resume];
}
@end
