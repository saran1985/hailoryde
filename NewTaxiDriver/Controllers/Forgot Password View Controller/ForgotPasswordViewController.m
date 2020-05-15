//
//  ForgotPasswordViewController.m
//  Tibs-Taxi-Customer
//
//  Created by Admin on 07/08/18.
//  Copyright © 2018 BLYNC. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "Constant.h"
#import "ForgotPasswordOtpViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ForgotPasswordViewController ()<UITextFieldDelegate>{
    NSString *key,*value;
    NSUserDefaults *def;
    __weak IBOutlet UIView *view_main;
}
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UITextField *txt_pwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_send;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, view_main.frame.size.height);
    
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    _txt_pwd.delegate=self;
//    _btn_send.layer.cornerRadius=20;
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
- (IBAction)send_doAction:(id)sender {
    [self.view endEditing:YES];
    BOOL numValidation=[self mbleNumVal:_txt_pwd.text];
    if ([_txt_pwd.text isEqualToString:@""]||[_txt_pwd.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MBLEVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
        
    }
    else if (_txt_pwd.text.length<10 || _txt_pwd.text.length>10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MBLERANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!numValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:MBLENUMVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        def=[NSUserDefaults standardUserDefaults];
        [def setObject:_txt_pwd.text forKey:@"mobile"];
        [def synchronize];
        [self postMethod];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
}
- (IBAction)back_doAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)postMethod{
    NSString *mble=_txt_pwd.text;
    def=[NSUserDefaults standardUserDefaults];
//    mble = [mble stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?mobile=%@&user_type=%@",BASE_URL,@"getOtpMobile",_txt_pwd.text,@"1"]];
    //     NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?rideId=%@&statusId=%@&destination=%@",BASE_URL,@"updateTripStatus",_rideid,@"2",_toloc]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Http Url  :  %@",urlRequest);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    
    [request setHTTPMethod:@"GET"];
    
    
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
                
                else if (httpResponse.statusCode==200) {
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    NSLog(@"The response is dict - %@",responseDictionary);
                    NSString *returnstring=[responseDictionary valueForKey:@"isError"];
                    BOOL error=[returnstring boolValue];
                    if (error==0 || error==false) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self->_loadingView removeFromSuperview];
                            self->key=[responseDictionary valueForKeyPath:@"response.key"];
                            self->value=[responseDictionary valueForKeyPath:@"response.value"];
                            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            ForgotPasswordOtpViewController *forgot = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordOtpViewController"];
                            forgot.mble=mble;
                            forgot.key=self->key;
                            forgot.value=self->value;
                            [self presentViewController:forgot animated:YES completion:nil];
                            
                        });
                    }
                    else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self->_loadingView removeFromSuperview];
                            //                     [self getotp];
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                            [alert show];
                        });
                    }
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->_loadingView removeFromSuperview];
                        //                [self getotp];
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
-(BOOL)mbleNumVal:(NSString*)mble{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:mble];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
}
@end
