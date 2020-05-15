//
//  LoginViewController.m
//  Driver
//
//  Created by Admin on 22/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "LoginViewController.h"
#import "AlertViewController.h"
#import "Constant.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "ForgotPasswordViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSUserDefaults *def;
    NSString *acc_tok,*exp_in,*tok_typ,*driid,*email,*ins_num,*lic_num,*mble,*model,*name,*plat_num,*image,*cabtype;
    __weak IBOutlet UIView *view_main;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *txt_mble;
@property (weak, nonatomic) IBOutlet UITextField *txt_pwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;

@end

@implementation LoginViewController

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
//    _btn_login.layer.cornerRadius=20;
    //    _btn_login.layer.borderColor=
    
    _txt_mble.delegate=self;
    _txt_pwd.delegate=self;
    
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    single.delegate=self;
    single.numberOfTapsRequired=1;
    single.numberOfTouchesRequired=1;
//    single.numberOfTapsRequired=2;
//    single.numberOfTouchesRequired=2;
    [_scroll addGestureRecognizer:single];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
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
//    [self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)login_doAction:(id)sender {
    [self.view endEditing:YES];
    BOOL numValidation=[self mbleNumVal:_txt_mble.text];
    if ([_txt_mble.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MBLEVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!numValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:MBLENUMVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (_txt_mble.text.length<10 || _txt_mble.text.length>10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MBLERANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_pwd.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PWDVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (_txt_pwd.text.length<6){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PWDRANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        [self postMethod];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
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
    [def setObject:_txt_pwd.text forKey:@"password"];
    [def synchronize];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Login",LOGIN_URL]]];
    NSLog(@"URL : %@",urlRequest);
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://test.canadiansaferide.com/Login"]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSString *platform=[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    NSString *userUpdate =[NSString stringWithFormat:@"grant_type=%@&username=%@&password=%@&user_type=%@&device_id=%@&platform=%@",@"password",_txt_mble.text,_txt_pwd.text,@"1",[def valueForKey:@"fcm"],platform];
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
        if(!error){
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
//            NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"The response is1 - %@",responseDictionary);
            NSLog(@"The response is2 - %@",[self->def valueForKey:@"UserLogin"]);
//            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch ([textField tag]) {
        case 1:
            [_scroll setContentOffset:CGPointMake(0, 35) animated:YES];
            
            break;
        case 2:
            [_scroll setContentOffset:CGPointMake(0, 100) animated:YES];
            break;
            
            
            
        default:
            break;
    }
}
-(BOOL)mbleNumVal:(NSString*)mble{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:mble];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [downloadTask resume];
}
- (IBAction)forgot:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self presentViewController:view animated:YES completion:nil];
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
@end
