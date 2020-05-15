//
//  ProfileViewController.m
//  NewTaxiDriver
//
//  Created by SPEXTRUM on 01/08/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constant.h"
#import "AlertViewController.h"
#import "ChangePasswordViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "FrontViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ProfileViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSUserDefaults *def;
    NSString *encodedString,*cabtype;
    __weak IBOutlet UIView *view_main;
    int check;
    NSData *test;
}
@property (weak, nonatomic) IBOutlet UITextField *txt_cnfpwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_update;
@property (weak, nonatomic) IBOutlet UITextField *txt_pwd;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_mble;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *img_profile;

@end

@implementation ProfileViewController

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
    check=0;
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    
//    _txt_name.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _txt_name.layer.borderWidth=2;
//    _txt_email.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _txt_email.layer.borderWidth=2;
//    _txt_pwd.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _txt_pwd.layer.borderWidth=2;
//    _txt_cnfpwd.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _txt_cnfpwd.layer.borderWidth=2;
//    _txt_mble.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _txt_mble.layer.borderWidth=2;
//    _txt_mble.enabled = NO;
    
    _txt_mble.delegate=self;
    _txt_pwd.delegate=self;
    _txt_name.delegate=self;
    _txt_email.delegate=self;
    _txt_cnfpwd.delegate=self;
    _txt_pwd.userInteractionEnabled=NO;
    _txt_mble.userInteractionEnabled=NO;
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    single.delegate=self;
    single.numberOfTapsRequired=1;
    single.numberOfTouchesRequired=1;
    //    single.numberOfTapsRequired=2;
    //    single.numberOfTouchesRequired=2;
    [_scroll addGestureRecognizer:single];
//    _btn_update.layer.cornerRadius=20;
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
- (IBAction)back_doAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)update_doAction:(id)sender {
    [self.view endEditing:YES];
    BOOL nameValidation=[self isValidName:_txt_name.text];
    BOOL emailValidation=[self validateEmailWithString:_txt_email.text];
    if ([_txt_name.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NAMEVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!nameValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:NAMESTRVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_mble.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MBLEVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_email.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:EMAILVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!emailValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:EMAILSTRVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
//    else if ([_txt_pwd.text isEqual:@""]) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
//    else if ([_txt_cnfpwd.text isEqual:@""]) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter confirm password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
//    else if (![_txt_pwd.text isEqual:_txt_cnfpwd.text]){
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Password mismatch" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
    else{
        [self postmethod];
    }
}
- (IBAction)signout_doAction:(id)sender {
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOGOUTHEA message:LOGOUT delegate:self cancelButtonTitle:nil otherButtonTitles:NOBUT,YESBUT, nil];
    alert.delegate=self;
    alert.tag=1;
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1 && buttonIndex==1){
        def=[NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:@"acc_tok"];
        [def removeObjectForKey:@"email"];
        [def removeObjectForKey:@"exp_in"];
        [def removeObjectForKey:@"ins"];
        [def removeObjectForKey:@"lic"];
        [def removeObjectForKey:@"mobile"];
        [def removeObjectForKey:@"model"];
        [def removeObjectForKey:@"name"];
        [def removeObjectForKey:@"driid"];
        [def removeObjectForKey:@"tok_type"];
        [def removeObjectForKey:@"plat"];
        [def setObject:@"0" forKey:@"UserLogin"];
        [def removeObjectForKey:@"onoff"];
        [def synchronize];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FrontViewController *front = [storyboard instantiateViewControllerWithIdentifier:@"FrontViewController"];
        [self presentViewController:front animated:YES completion:nil];
    }
    else if (alertView.tag==2) {
        if (buttonIndex==0) {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera]){
                
                
                UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
                imagepicker.delegate = self;
                imagepicker.allowsEditing = YES;
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    
                    if(status == AVAuthorizationStatusAuthorized) {
                        
                        [self presentViewController:imagepicker animated:YES completion:NULL];
                        NSLog(@"camera authorized");
                    } else if(status == AVAuthorizationStatusDenied){
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:@"Dear Driver Please allow to access camera for uploading profile image" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                        
                        NSLog(@"camera denied");
                        // denied
                    } else if(status == AVAuthorizationStatusRestricted){
                        
                        NSLog(@"camera restricted");
                        // restricted
                    } else if(status == AVAuthorizationStatusNotDetermined){
                        // [self presentViewController:picker animated:YES completion:NULL];
                        NSLog(@"camera Granted access1");
                        // not determined
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                            if(granted){
                                [self presentViewController:imagepicker animated:YES completion:NULL];
                                NSLog(@"camera Granted access2");
                            } else {
                                [imagepicker dismissViewControllerAnimated:YES completion:NULL];
                                NSLog(@"camera Not granted access");
                            }
                        }];
                    }
                }
            }
        }
        else if (buttonIndex==1){
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.allowsEditing=YES;
            imagepicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
        else{
            
        }
    }
    else {
        
    }
}
-(void)setValues{
_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def = [NSUserDefaults standardUserDefaults];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                self->_txt_name.text = [NSString stringWithFormat:@"%@",[self->def valueForKey:@"name"]];
                self->_txt_mble.text = [NSString stringWithFormat:@"%@",[self->def valueForKey:@"mobile"]];
                self->_txt_email.text = [NSString stringWithFormat:@"%@",[self->def valueForKey:@"email"]];
//                    self->_txt_pwd.text = [NSString stringWithFormat:@"%@",[self->def valueForKey:@"password"]];
                self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width / 2;
                self.img_profile.clipsToBounds = YES;
//                [self image];
                if (![self->def valueForKey:@"newprofile"]||[[self->def valueForKey:@"newprofile"] isEqual:(id)[NSNull null]]) {
                    self.img_profile.image= [UIImage imageNamed:@"profile.png"];
                }
                NSData *imageData = [self->def valueForKey:@"newprofile"];
                //                NSData *imageData = [[NSData alloc]initWithBase64EncodedString:response1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                if (imageData.length==0) {
                    self.img_profile.image= [UIImage imageNamed:@"profile.png"];
                }
                else {
                    
                    self.img_profile.image=[UIImage imageWithData:imageData];
                    
                }
            });
}
-(void)postmethod
{
    check=1;
    encodedString=[NSString stringWithFormat:@"%@.jpg",encodedString];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    def=[NSUserDefaults standardUserDefaults];
    def = [NSUserDefaults standardUserDefaults];
    NSLog(@"User Id  :  %@",[def valueForKey:@"userid"]);
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"updateDriver",[def valueForKey:@"driid"]]]];
    NSLog(@"Url Req  :  %@",urlRequest);
    
    NSDictionary *params = @{@"name" : _txt_name.text, @"password" : @"", @"email" : _txt_email.text, @"mobile" : _txt_mble.text,@"user_type" : @"1" ,@"profile_image" : encodedString};
    
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
                    self->def=[NSUserDefaults standardUserDefaults];
                    if (self->test.length==0||[self->test isEqual:@""]) {
                        
                    }
                    else{
                        self->def=[NSUserDefaults standardUserDefaults];
                        [self->def setObject:self->test forKey:@"newprofile"];
                        [self->def synchronize];
                    }
                    [self->def setObject:self->_txt_name.text forKey:@"name"];
                    [self->def setObject:self->_txt_email.text forKey:@"email"];
                    [self->def synchronize];
                    [self->_loadingView removeFromSuperview];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:LOGOUTSUC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert1 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert1 animated:YES completion:nil];
                    
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
        else if (httpResponse.statusCode == 403){
            NSString *error=[responseDictionary valueForKey:@"errorMessage"];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=1;
            [self login];
            });
        }
        else
        {
            NSLog(@"Error  :  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self->_loadingView removeFromSuperview];
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Connection error. Please check your internet connection." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alert show];
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
-(BOOL)isValidName:(NSString *)passwordString
{
    NSString *alphaNum = @"[a-zA-Z. ]+";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNum];
    return [regexTest evaluateWithObject:passwordString];
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex  = @"\\A[A-Za-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [test1 evaluateWithObject:email] && [test2 evaluateWithObject:email];
}
- (IBAction)changePwd_doAction:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangePasswordViewController *change = [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self presentViewController:change animated:YES completion:nil];
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
        if (httpResponse.statusCode==0 || data==nil){
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
                    [self postmethod];
                }
                else if (self->check==2){
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
    }];
    [dataTask resume];
}
-(void)resign{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch ([textField tag]) {
        case 1:
            [_scroll setContentOffset:CGPointMake(0, 35) animated:YES];
            
            break;
        case 2:
            [_scroll setContentOffset:CGPointMake(0, 70) animated:YES];
            break;
            
        case 3:
            [_scroll setContentOffset:CGPointMake(0, 100) animated:YES];
            break;
            
        case 4:
            [_scroll setContentOffset:CGPointMake(0, 130) animated:YES];
            break;
        default:
            break;
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
- (IBAction)image_doAction:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Add Profile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose from gallery",@"Cancel", nil];
    alert.delegate=self;
    alert.tag=2;
    [alert show];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *pngData2 = UIImageJPEGRepresentation(chosenImage,0);
    int imageSize1   = pngData2.length;
    NSLog(@"size of image in KB: %@ ", chosenImage);
    NSData *pngData1 = UIImageJPEGRepresentation(chosenImage,0.01);
    int imageSize   = pngData1.length;
    NSLog(@"size of image in KB: %f ", imageSize/1024.0);
    NSLog(@"Img Data  :  %@",pngData1);
    // NSData *pngData2 = UIImagePNGRepresentation(chosenImage);
    
    NSLog(@"IMAGE NAME : %@",chosenImage);
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(chosenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    self.img_profile.image = chosenImage;
//    encodedString = [[self base64forData:pngData1] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSData *data = UIImagePNGRepresentation(chosenImage);
    encodedString=[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    test=data;
    NSLog(@"Str  :  %@",encodedString);
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}
- (NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
-(void)image{
    //-LQ8ppkPCzkywOEjPq4z
    check=2;
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?driverId=%@",BASE_URL,@"getBaseProfileImage",[def valueForKey:@"driid"]]];
    NSLog(@"Http Url  :  %@",url2);
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
            if (httpResponse.statusCode==200) {
                
           
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Dict  :  %@",responseDictionary);
            NSString *response1=[responseDictionary valueForKeyPath:@"response.image"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *imageData = [self dataFromBase64EncodedString:response1];
                if (imageData.length==0) {
                    self.img_profile.image = [UIImage imageNamed:@"profile.png"];
                }
                else {
                    
                    self.img_profile.image=[UIImage imageWithData:imageData];
                    
                }
                
            });
            NSLog(@"Tot Resp  :  %@",response1);
                
            }
            else if(httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=2;
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
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
@end
