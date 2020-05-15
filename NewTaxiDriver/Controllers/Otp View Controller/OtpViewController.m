//
//  OtpViewController.m
//  Customer
//
//  Created by Admin on 20/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "OtpViewController.h"
#import "Constant.h"
#import "AlertViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "LoginViewController.h"
@import Firebase;
#import <FirebaseAuth.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface OtpViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSTimer *timer;
    int hours, minutes, seconds;
    int secondsLeft;
    NSUserDefaults *def;
    NSString *acc_tok,*exp_in,*tok_typ,*driid,*email,*ins_num,*lic_num,*mble,*model,*name,*plat_num,*encodedString,*filename,*image,*key,*value,*verification,*cabtype;
    NSString *localNumberCode,*countryCode;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *txt_otp;
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_timer;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation OtpViewController
- (IBAction)resend_doAction:(id)sender {

    [self getotp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
   
    self.manWalkingImageView.animatedImage = manWalkingImage;

    _txt_otp.delegate=self;
    _txt_otp.userInteractionEnabled=YES;
//    _btn_submit.layer.cornerRadius=20;
    
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    single.delegate=self;
    single.numberOfTapsRequired=1;
    single.numberOfTouchesRequired=1;

    [self.scroll addGestureRecognizer:single];
    [FIRAuth auth].languageCode = @"en";
    NSLocale *locale = [NSLocale currentLocale];
    countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSDictionary *dict = [self dictCountryCodes];
    localNumberCode = dict[countryCode];
    NSLog(@"Number1  :  %@",localNumberCode);
    [self getotp];    // Do any additional setup after loading the view.
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
    [timer invalidate];
    timer=nil;
    [self stopTimer];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submit_doAction:(id)sender {
    [self.view endEditing:YES];
    BOOL numValidation=[self mbleNumVal:_txt_otp.text];
    if ([_txt_otp.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:OTPVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!numValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:OTPNUMVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        [timer invalidate];
        timer=nil;
        [self stopTimer];
        [self verifyotp];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)resign{
    [self.view endEditing:YES];
    [_txt_otp resignFirstResponder];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)countdownTimer {
    secondsLeft = 120;
    secondsLeft = hours = minutes = seconds = 120;
    if([timer isValid]) {
        //[timer release];
    }
    //  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}
- (void)updateCounter:(NSTimer *)theTimer {//[MCLocalization sharedInstance].language = @"en"
    if(secondsLeft > 0 ) {
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        _lbl_timer.text=[NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else{
        _lbl_timer.text=[NSString stringWithFormat:@"00:00"];
        [timer invalidate];
        timer=nil;
        [self stopTimer];
    }
}
-(void)stopTimer{
    if ([timer isValid]) {
        [timer invalidate];
        timer=nil;
    }
    else{
    [timer invalidate];
    timer=nil;
    }
}
-(void)postMethod{
        _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.loadingView.alpha=0.7;
        [self.view addSubview:_loadingView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            [self->_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        });
        def=[NSUserDefaults standardUserDefaults];
    
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Login",LOGIN_URL]]];
        //    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://test.canadiansaferide.com/Login"]]];
        //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        NSString *platform=[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
        NSString *userUpdate =[NSString stringWithFormat:@"grant_type=%@&username=%@&password=%@&user_type=%@&device_id=%@&platform=%@",@"password",[def valueForKey:@"mobile"],[def valueForKey:@"password"],@"1",[def valueForKey:@"fcm"],platform];
        NSLog(@"Login input  :  %@",userUpdate);
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
                self->def=[NSUserDefaults standardUserDefaults];
                self->acc_tok = [responseDictionary valueForKey:@"access_token"];
                self->email=[responseDictionary valueForKey:@"email"];
                self->exp_in=[responseDictionary valueForKey:@"expires_in"];
                self->ins_num=[responseDictionary valueForKey:@"insurancenumber"];
                self->lic_num=[responseDictionary valueForKey:@"licensenumber"];
                self->mble=[responseDictionary valueForKey:@"mobile"];
                self->model=[responseDictionary valueForKey:@"model"];
                self->name=[responseDictionary valueForKey:@"name"];
                self->driid=[responseDictionary valueForKey:@"driver_id"];
                self->tok_typ=[responseDictionary valueForKey:@"token_type"];
                self->plat_num=[responseDictionary valueForKey:@"platenumber"];
                self->image=[responseDictionary valueForKey:@"profile_image"];
                NSString *cab=[responseDictionary valueForKey:@"cab_type"];
                [self->def setObject:self->acc_tok forKey:@"acc_tok"];
                [self->def setObject:self->email forKey:@"email"];
                [self->def setObject:self->exp_in forKey:@"exp_in"];
                [self->def setObject:self->ins_num forKey:@"ins"];
                [self->def setObject:self->lic_num forKey:@"lic"];
                [self->def setObject:self->mble forKey:@"mobile"];
                [self->def setObject:self->model forKey:@"model"];
                [self->def setObject:self->name forKey:@"name"];
                [self->def setObject:self->driid forKey:@"driid"];
                [self->def setObject:self->tok_typ forKey:@"tok_type"];
                [self->def setObject:self->plat_num forKey:@"plat"];
                [self->def setObject:self->image forKey:@"profile"];
                if (cab == (id)[NSNull null]){
                    self->cabtype=@"";
                }
                else{
                    self->cabtype=cab;
                }
                [self->def setObject:self->cabtype forKey:@"cabtype"];
                [self->def setObject:@"1" forKey:@"UserLogin"];
                [self->def synchronize];
                NSLog(@"The response is1 - %@",responseDictionary);
                NSLog(@"The response is2 - %@",[self->def valueForKey:@"UserLogin"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                [self->_loadingView removeFromSuperview];
                    [self image];
                    
                    
                });
            }
            else if (httpResponse.statusCode==400){
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"error_description"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            else if (httpResponse.statusCode==500){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSError *parseError = nil;
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"error_description"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                });
            }
            
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"error_description"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
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
}
-(BOOL)mbleNumVal:(NSString*)mble{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:mble];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
}
-(void)getotp{
    def=[NSUserDefaults standardUserDefaults];
//    NSString *countymble = [NSString stringWithFormat:@"%%2B91%@",[self->def valueForKey:@"mobile"]];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?mobile=%@&user_type=%@",BASE_URL,@"getOtpMobile",[self->def valueForKey:@"mobile"],@"1"]];
    //     NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",_rideid,@"2",_toloc]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Http Url  :  %@",urlRequest);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    
    [request setHTTPMethod:@"GET"];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        NSError *parseError = nil;
        if (httpResponse.statusCode==200) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is dict - %@",responseDictionary);
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error=[returnstring boolValue];
            if (error==0 || error==false) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    self->key=[responseDictionary valueForKeyPath:@"response.key"];
                    self->value=[responseDictionary valueForKeyPath:@"response.value"];
                    //                     self->_txt_otp.text=[NSString stringWithFormat:@"%@",self->value];
                });
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    //                     [self getotp];
                });
            }
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                //                [self getotp];
            });
        }
        
    }];
    [dataTask resume];
/*
    def=[NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *mblenum=[NSString stringWithFormat:@"+%@%@",self->localNumberCode,[self->def valueForKey:@"mobile"]];
        NSString *mblenum=[NSString stringWithFormat:@"+%@%@",@"91",[self->def valueForKey:@"mobile"]];
        NSLog(@"Final mble num  :  %@",mblenum);
        self->_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self->_loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.loadingView.alpha=0.7;
        [self.view addSubview:self->_loadingView];
        [[FIRPhoneAuthProvider provider] verifyPhoneNumber:mblenum
                                                UIDelegate:nil
                                                completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
                                                    self->verification=verificationID;
                                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                    [defaults setObject:self->verification forKey:@"authVerificationID"];
                                                    [defaults synchronize];
                                                    if (error) {
                                                        [self->_loadingView removeFromSuperview];
                                                        NSLog(@"ERROR1  :  %@",error);
                                                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                                                        [alert show];
                                                        return;
                                                    }
                                                    else{
                                                        [self->_loadingView removeFromSuperview];
                                                        NSLog(@"SUCESS1");
                                                        //sucess code
                                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                        [defaults setObject:self->verification forKey:@"authVerificationID"];
                                                        [defaults synchronize];
                                                    }
                                                    // Sign in using the verificationID and the code sent to the user
                                                    // ...
                                                }];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self->verification forKey:@"authVerificationID"];
        [defaults synchronize];
    });
 */
}
-(void)verifyotp{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"verifyOtp"]]];
    NSDictionary *params = @{@"key" : key, @"value" : _txt_otp.text};
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    NSLog(@"User Update  :  %@",jsonInputString);
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Convert the String to Data
    NSData *data1 = [jsonInputString dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        NSDictionary *responseDictionary1 = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"The response dict is - %@",responseDictionary1);
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response dict is - %@",responseDictionary);
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error=[returnstring boolValue];
            if (error==0 || error==false) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    [self login];
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
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([[responseDictionary valueForKey:@"isError"]integerValue]==1) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Maximum trials exceeded" message:@"Sorry! You have exceeded the maxi trials on OTP. Please request for a new OTP and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
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
    }];
    [dataTask resume];
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self->_loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        self.loadingView.alpha=0.7;
        [self.view addSubview:self->_loadingView];
        self->def=[NSUserDefaults standardUserDefaults];
        NSString *verificationID = [self->def stringForKey:@"authVerificationID"];
        FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider]
                                         credentialWithVerificationID:verificationID
                                         verificationCode:self->_txt_otp.text];
        [[FIRAuth auth] signInAndRetrieveDataWithCredential:credential
                                                 completion:^(FIRAuthDataResult * _Nullable authResult,
                                                              NSError * _Nullable error) {
                                                     if (error) {
                                                         // ...
                                                         [self->_loadingView removeFromSuperview];
                                                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                                                         [alert show];
                                                         NSLog(@"ERROR2");
                                                         return;
                                                     }
                                                     else{
                                                         NSLog(@"SUCESS2");
                                                         [self->_loadingView removeFromSuperview];
                                                         [self login];
                                                     }
                                                     // User successfully signed in. Get user data from the FIRUser object
                                                     if (authResult == nil) {
                                                         NSLog(@"SUCESS3");
                                                         return;
                                                     }
                                                     NSLog(@"SUCESS4");
                                                     FIRUser *user = authResult.user;
                                                     NSLog(@"User  :  %@",user);
                                                     // ...
                                                 }];
    });
     */

}
-(NSDictionary *)dictCountryCodes{
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"93", @"AF",@"20",@"EG", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    return dictCodes;
}
-(void)login{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driver_id=%@&mobile=%@",BASE_URL,@"verifyUser",[def valueForKey:@"driid"],[self->def valueForKey:@"mobile"]]];
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
//                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    LoginViewController *booking = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                    [self presentViewController:booking animated:YES completion:nil];
                    [self postMethod];
                    
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
-(void)image{
    //-LQ8ppkPCzkywOEjPq4z
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"getBaseProfileImage",[def valueForKey:@"driid"]]];
    NSLog(@"menu Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    //    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    
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
            
            else  if (httpResponse.statusCode==200) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"Resp  :  %@",responseDictionary);
                NSString *response1=[responseDictionary valueForKeyPath:@"response.image"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSData *imageData = [self dataFromBase64EncodedString:response1];
                    [def setObject:imageData forKey:@"newprofile"];
                    [def synchronize];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                });
                NSLog(@"Tot Resp  :  %@",response1);
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self postMethod];
                });
            }
            else if (httpResponse.statusCode==403){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
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
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
}
@end
