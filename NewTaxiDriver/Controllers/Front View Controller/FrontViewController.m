//
//  FrontViewController.m
//  Driver
//
//  Created by Admin on 22/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "FrontViewController.h"
#import "Reachability.h"
#import "ViewController.h"
#import "AlertViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface FrontViewController (){
    NSString *userlogin;
    NSUserDefaults *def;
    Reachability *networkReachability;
    NetworkStatus networkStatus;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_alert;

@end

@implementation FrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
    def=[NSUserDefaults standardUserDefaults];
    userlogin=[def valueForKey:@"UserLogin"];
    NSLog(@"user : %@",userlogin);
    _lbl_alert.hidden=YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(presentnextView) userInfo:nil repeats:YES];
    
    
//    NSDictionary *firstJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         @"", @"delete_status",
//                                         @"", @"user_id",
//                                         @"", @"value",
//                                         nil];
//    
//    NSDictionary *secondJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          @"", @"delete_status",
//                                          @"", @"user_id",
//                                          @"", @"value",
//                                          nil];
//    
//    NSMutableArray * arr = [[NSMutableArray alloc] init];
//    
//    [arr addObject:firstJsonDictionary];
//    [arr addObject:secondJsonDictionary];
//    
//    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
//    NSLog(@"jsonData as string:\n%@", jsonString);
//    
//    
//    
//    NSDictionary *params = @{
//                             @"driver_profile" : @{@"name" : @"", @"password" : @"", @"email" : @"", @"mobile" :@"",@"user_type" : @"1" },
//                             @"driver_details" : @{@"insurance_number": @"", @"license_number": @"", @"model": @"",@"plate_number": @"",@"rating": @"",@"driver_id": @"",@"verify_status" : @"",@"profile_status" : @"",@"account_status" : @"" },
//                             //                                 @"documents" : @{@"delete_status": @"",@"user_id": @"",@"value":@""}
//                             @"documents" : arr
//                             };
//    
//    NSError *error = nil;
//    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
//    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    
    
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
-(void)presentnextView{
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable){
        _lbl_alert.hidden=NO;
    }
    else if ([userlogin isEqual:@"1"]|| [userlogin isEqualToString:@"1"]) {
        [timer invalidate];
        timer = nil;
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AlertViewController *alert = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [timer invalidate];
        timer = nil;
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:view animated:YES completion:nil];
    }
}
@end
