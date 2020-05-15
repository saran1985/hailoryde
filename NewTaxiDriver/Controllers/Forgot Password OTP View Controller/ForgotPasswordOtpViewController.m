//
//  ForgotPasswordOtpViewController.m
//  Tibs-Taxi-Customer
//
//  Created by Admin on 24/09/18.
//  Copyright © 2018 BLYNC. All rights reserved.
//

#import "ForgotPasswordOtpViewController.h"
#import "ForgotPasswordNewPwdViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "Constant.h"
@import Firebase;
#import <FirebaseAuth.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ForgotPasswordOtpViewController ()<UITextFieldDelegate>{
    NSUserDefaults *def;
    NSString *localNumberCode,*countryCode,*verification;
}
@property (weak, nonatomic) IBOutlet UITextField *txt_otp;
@property (weak, nonatomic) IBOutlet UIButton *btn_send;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;

@end

@implementation ForgotPasswordOtpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
   
    self.manWalkingImageView.animatedImage = manWalkingImage;
    _txt_otp.delegate=self;
//    _txt_otp.text=[NSString stringWithFormat:@"%@",_value];
    [_txt_otp setUserInteractionEnabled:YES];
    [FIRAuth auth].languageCode = @"en";
    NSLocale *locale = [NSLocale currentLocale];
    countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSDictionary *dict = [self dictCountryCodes];
    localNumberCode = dict[countryCode];
    NSLog(@"Number1  :  %@",localNumberCode);
//    [self getotp];
//    _btn_send.layer.cornerRadius=20;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)send_doAction:(id)sender {
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
        [self verifyotp];
    }
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
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"verifyOtp"]]];
    NSDictionary *params = @{@"key" : _key, @"value" : _value};
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
                    ForgotPasswordNewPwdViewController *forgot = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordNewPwdViewController"];
                    [self presentViewController:forgot animated:YES completion:nil];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
        else
            {
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
-(void)getotp{
//    NSString *countymble = [NSString stringWithFormat:@"%%2B91%@",_mble];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?mobile=%@&user_type=%@",BASE_URL,@"getOtpMobile",_mble,@"1"]];
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
                    self->_key=[responseDictionary valueForKeyPath:@"response.key"];
                    self->_value=[responseDictionary valueForKeyPath:@"response.value"];
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

}
-(void)verifyotp{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"verifyOtp"]]];
    NSDictionary *params = @{@"key" : _key, @"value" : _txt_otp.text};
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
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ForgotPasswordNewPwdViewController *booking = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordNewPwdViewController"];
                    booking.mble=self->_mble;
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
-(BOOL)mbleNumVal:(NSString*)mble{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:mble];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
}
- (IBAction)resend_doAction:(id)sender {
    [self getotp];
}
@end
