//
//  CancelViewController.m
//  NewTaxiDriver
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "CancelViewController.h"
#import "Constant.h"
#import "AlertViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface CancelViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSUserDefaults *def;
    NSMutableArray *cancelReason,*cancelId;;
    NSString *cancel,*canid,*cabtype;
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UIView *view_main;
    int check,val;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *lbl_cancel;
@property (weak, nonatomic) IBOutlet UIView *view_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, view_main.frame.size.height);
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        scroll.frame=CGRectMake(0, statusBar.frame.size.height+view_main.frame.size.height, self.view.frame.size.width, self->scroll.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//
//    }
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    _table.hidden=YES;
    check=0;
    val=0;
    cancelReason=[[NSMutableArray alloc]init];
    cancelId=[[NSMutableArray alloc]init];
    _lbl_cancel.textColor=[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
    //    _btn_cancel.layer.cornerRadius=20;
    //    _btn_cancel.layer.borderColor=
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
- (IBAction)cancel_doACTION:(id)sender {
    if (cancel.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELONEREA delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        [self postMethod];
    }
}
- (IBAction)back_doAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelreasonlist_doAction:(id)sender {
    check=1;
    if(val==0){
        [self cancelReason];
        val=1;
    }
    else{
        _table.hidden=YES;
        val=0;
    }
    
}
-(void)cancelReason{
    cancelReason=[[NSMutableArray alloc]init];
    cancelId=[[NSMutableArray alloc]init];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    
    
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    //    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?lat=%@&lon=%@",BASE_URL,@"getCancelReason",@"11.0168445",@"76.9558321"]];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"getCancelReason"]];
    //    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?lat=%@&lon=%@",BASE_URL,@"getCancelReason",[def valueForKey:@"picklat"],[def valueForKey:@"picklon"]]];
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
                NSLog(@"Json1  :  %@",responseDictionary);
                NSArray *arr=[responseDictionary valueForKey:@"response"];
                NSLog(@"Json2  :  %@",arr);
                for (int i=0; i<arr.count; i++) {
                    NSString *can=[[responseDictionary valueForKey:@"response"]objectAtIndex:i];
                    NSLog(@"Json Str  :  %@",can);
                    [self->cancelReason addObject:can];
                    NSString *str=[NSString stringWithFormat:@"%d",i];
                    [self->cancelId addObject:str];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    //                    CGRect frame = self.table.frame;
                    //                    frame.size.height = self.table.contentSize.height;
                    //                    self.table.frame = frame;
                    CGFloat height = 44.0;
                    height *= self->cancelReason.count*1.1;
                    NSLog(@"Height  :  %f",height);
                    CGRect tableFrame = self.table.frame;
                    tableFrame.size.height = height;
                    self.table.frame = tableFrame;
                    //                    _table.frame=CGRectMake(16,226,343,height);
                    //                    [self.view addSubview:_table];
                    [self->_table setHidden:NO];
                    [self->_table reloadData];
                    
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self login];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                });
            }
            // id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cancelReason.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    _table.separatorColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.5];    cell.textLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    cell.textLabel.text =  [cancelReason objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_lbl_cancel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        self->_lbl_cancel.text=[NSString stringWithFormat:@"%@",self->cancel];
        [self->_table setHidden:YES];
        //        [self->_table removeFromSuperview];
    });
    val=0;
    canid=[cancelId objectAtIndex:indexPath.row];
    cancel=[cancelReason objectAtIndex:indexPath.row];
}
-(void)login {
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Login",LOGIN_URL]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSString *platform=[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    NSString *userUpdate =[NSString stringWithFormat:@"grant_type=%@&username=%@&password=%@&user_type=%@&device_id=%@&platform=%@",@"password",[def valueForKey:@"mobile"],[def valueForKey:@"password"],@"1",[def valueForKey:@"fcm"],platform];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
            });
        }
        else{
        if(httpResponse.statusCode == 200)
        {
            self->def=[NSUserDefaults standardUserDefaults];
            NSString *access_token = [responseDictionary valueForKey:@"access_token"];
            NSString *email=[responseDictionary valueForKey:@"email"];
            NSString *exp_in=[responseDictionary valueForKey:@"expires_in"];
            NSString *mble=[responseDictionary valueForKey:@"mobile"];
            NSString *name=[responseDictionary valueForKey:@"name"];
            NSString *token_type=[responseDictionary valueForKey:@"token_type"];
            NSString *userid=[responseDictionary valueForKey:@"user_id"];
            NSString *cab=[responseDictionary valueForKey:@"cab_type"];
            [self->def setObject:access_token forKey:@"acc_tok"];
            [self->def setObject:email forKey:@"email"];
            [self->def setObject:exp_in forKey:@"exp_in"];
            [self->def setObject:mble forKey:@"mobile"];
            [self->def setObject:name forKey:@"name"];
            [self->def setObject:token_type forKey:@"tok_type"];
            [self->def setObject:userid forKey:@"userid"];
            if (cab == (id)[NSNull null]){
                self->cabtype=@"";
            }
            else{
                self->cabtype=cab;
            }
            [self->def setObject:self->cabtype forKey:@"cabtype"];
            [self->def setObject:@"1" forKey:@"UserLogin"];
            [self->def synchronize];
            NSLog(@"Login User Id  :  %@",[self->def valueForKey:@"driid"]);
            NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"The response is - %@",returnstring);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->check==1) {
                    [self cancelReason];
                }
                else if (self->check==2){
                    [self postMethod];
                }
                else if (self->check==3){
                    [self notifydriver];
                }
                else if (self->check==4){
                    [self online];
                }
                else{
                    
                }
                
            });
        }
        else if (httpResponse.statusCode==400){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
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
- (CGFloat)tableViewHeightOfTable:(UITableView *)table
{
    [table layoutIfNeeded];
    return [table contentSize].height;
}
-(void)postMethod{
    @try{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    check=2;
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    
    
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?ride_id=%@&driver_id=%@&comments=%@",BASE_URL,@"cancelTrip",[def valueForKey:@"notifyrideid"],[def valueForKey:@"driid"],canid]];
    //        NSString *str=[NSString stringWithFormat:@"%@%@?ride_id=%@&user_id=%@&comments=%@",BASE_URL,@"cancelTrip",@"-LIdv7NBL5jT-yBDDb1J",@"-LIPOaVjrXD62R9_e4KF",canid];
    //        NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]];
    NSLog(@"Http Url  :  %@",url2);
    NSLog(@"Url  :  %@%@ \n Ride id  :  %@\nUser id  :  %@\nCancel Comments  :  %@",BASE_URL,@"cancelTrip",[def valueForKey:@"notifyrideid"],[def valueForKey:@"userid"],cancel);
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
                NSString *returnstring=[responseDictionary valueForKey:@"isError"];
                BOOL error=[returnstring boolValue];
                NSLog(@"Json1  :  %d",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    //                    [self->def removeObjectForKey:@"notifyrideid"];
                    //                    [self->def synchronize];
                    if (error==0 || error==false) {
                        [self notifydriver];
                    }
                    else{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                        [alert show];
                    }
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self login];
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        }
    }];
    [downloadTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)notifydriver{
    @try{
    check=3;
    def=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *driid1=[[NSMutableArray alloc]init];
    [driid1  addObject: [def objectForKey:@"userid"]];
    //     NSLog(@"Can Tot dri  :  %@",driid1);
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSMutableURLRequest *urlRequest;
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&ride_id=%@&title=%@&message=%@",@"-LQCyPOl8ncU2QYzLTmX",[def valueForKey:@"rideid"],@"string",@"string"];
    //    NSString *userUpdate =[NSString stringWithFormat:@"driver_id=%@&ride_id=%@&title=%@&message=%@",driid,[def valueForKey:@"rideid"],@"string",@"string"];
    NSDictionary *params;
    urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"notifyDriver"]]];
    params = @{@"driver_id" : driid1 , @"ride_id" : [def valueForKey:@"notifyrideid"], @"title" : @"Taxi Driver", @"message" : CANNOT, @"cab_type" : [def valueForKey:@"cabtype"] };
    
    
    //                             };
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"name=%@&password=%@&email=%@&mobile=%@&user_type=%@",_txt_name.text,_txt_pwd.text,_txt_mail.text,_txt_mble.text,@"2"];
    NSLog(@"User Update  :  %@",jsonInputString);
    
    [urlRequest setHTTPMethod:@"POST"];
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
            NSLog(@"The response dict is - %@",responseDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->def removeObjectForKey:@"notifyrideid"];
                [self->def setObject:@"1" forKey:@"onoff"];
                [self->def synchronize];
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CANSUC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
                [self online];
//                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
//                [self presentViewController:alert11 animated:YES completion:nil];
            });
        }
        else if (httpResponse.statusCode==500){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"The response dict is 500- %@",responseDictionary);
                NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"The response is 500- %@",returnstring);
                NSLog(@"Error  :  %@",error);
            });
        }
        else if (httpResponse.statusCode==401){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->check=3;
                [self login];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"The response dict is 503- %@",responseDictionary);
                NSLog(@"Error  :  %@",error);
//                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
//                [self presentViewController:alert11 animated:YES completion:nil];
            });
        }
        }else{
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
}
-(void)online{
    @try{
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
                    [self->def setObject:@"1" forKey:@"onoff"];
                    [self->def synchronize];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert11 animated:YES completion:nil];
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
                        [self->def setObject:@"1" forKey:@"onoff"];
                        [self->def synchronize];
                        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                        [self presentViewController:alert11 animated:YES completion:nil];
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self->_loadingView removeFromSuperview];
                });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->check=4;
                    [self login];
                });
            }
            else if (httpResponse.statusCode==500){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    [self->def setObject:@"1" forKey:@"onoff"];
                    [self->def synchronize];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert11 animated:YES completion:nil];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    [self->def setObject:@"1" forKey:@"onoff"];
                    [self->def synchronize];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert11 animated:YES completion:nil];
                });
            }
            // NSLog(@"Json3  :  %@",returnstring);
            //            NSArray * resultDict =[json objectForKey:@"name"];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                [self->def setObject:@"1" forKey:@"onoff"];
                [self->def synchronize];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AlertViewController *alert11 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                [self presentViewController:alert11 animated:YES completion:nil];
            });
        }
        }
    }];
    [downloadTask resume];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end


