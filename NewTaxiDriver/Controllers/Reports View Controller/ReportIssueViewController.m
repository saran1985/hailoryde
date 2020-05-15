//
//  ReportIssueViewController.m
//  NewTaxiDriver
//
//  Created by Admin on 09/08/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ReportIssueViewController.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "AlertViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@interface ReportIssueViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>{
    NSUserDefaults *def;
    NSMutableArray *cancelReason,*cancelId;;
    NSString *cancel,*canid,*cabtype;
    __weak IBOutlet UIView *view_main;
    int check,val;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *lbl_val;
@property (weak, nonatomic) IBOutlet UITextView *txt;
@property (weak, nonatomic) IBOutlet UIView *view_report;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
#define MAX_LENGTH 200
@end

@implementation ReportIssueViewController

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
    check=0;
    _table.dataSource=self;
    _table.delegate=self;
    cancelReason=[[NSMutableArray alloc]init];
    cancelId=[[NSMutableArray alloc]init];
//    _btn_submit.layer.cornerRadius=20;
    //    _btn_submit.layer.borderColor=
    
    _txt.delegate=self;
    val=0;
//    _view_report.layer.borderWidth=2;
//    _view_report.layer.borderColor=[UIColor blackColor].CGColor;
    _lbl_val.textColor=[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
    _txt.layer.borderColor=[[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.5] CGColor];
    _txt.layer.borderWidth=1;
    _txt.textColor=[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
    _table.hidden=YES;
    [_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, 0)];
    (self.txt.transform = CGAffineTransformMakeTranslation(0.0,_view_report.frame.origin.y-200));
    _btn_submit.transform= CGAffineTransformMakeTranslation(0.0,_txt.frame.origin.y-80);
    
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
- (IBAction)dropdown_doAction:(id)sender {
    if(val==0){
        [self showIssues];
        val=1;
    }
    else{
        _table.hidden=YES;
        (self.txt.transform = CGAffineTransformMakeTranslation(0.0,_view_report.frame.origin.y-200));
        _btn_submit.transform= CGAffineTransformMakeTranslation(0.0,_txt.frame.origin.y-80);
        val=0;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submit_doAction:(id)sender {
    if (cancel.length==0&&([_txt.text isEqualToString:@"Type your comments"]||[_txt.text isEqual:@"Type your comments"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SELONEREA delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        [self postmethod];
    }
}
-(void)showIssues{
_loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    check=1;
    cancelReason=[[NSMutableArray alloc]init];
    cancelId=[[NSMutableArray alloc]init];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    //    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?lat=%@&lon=%@",BASE_URL,@"getCancelReason",@"11.0168445",@"76.9558321"]];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"getReportReasons"]];
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
            // id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
                [self->_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height*1.7)];
                CGFloat height = 44.0;
                height *= self->cancelReason.count*1.1;
                NSLog(@"Height  :  %f",height);
                CGRect tableFrame = self.table.frame;
                tableFrame.size.height = height+5;
                self.table.frame = tableFrame;
                (self.txt.transform = CGAffineTransformMakeTranslation(0.0,self->_table.frame.size.height-self->_txt.frame.size.height-30));
                self->_btn_submit.transform= CGAffineTransformMakeTranslation(0.0,self->_txt.frame.origin.y-265);
                [self->_table setHidden:NO];
                [self->_table reloadData];
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
        [self->_table setHidden:YES];
        self->_lbl_val.text=[NSString stringWithFormat:@"%@",[self->cancelReason objectAtIndex:indexPath.row]];
        self->_lbl_val.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        [self->_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, 0)];
        (self.txt.transform = CGAffineTransformMakeTranslation(0.0,self->_view_report.frame.origin.y-200));
        self->_btn_submit.transform= CGAffineTransformMakeTranslation(0.0,self->_txt.frame.origin.y-80);
    });
    val=0;
    canid=[cancelId objectAtIndex:indexPath.row];
    cancel=[cancelReason objectAtIndex:indexPath.row];
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
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (data==nil || httpResponse.statusCode==0) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self->_loadingView removeFromSuperview];
            });
        }
        if(httpResponse.statusCode == 200)
        {
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
                self->cabtype=@"";
            }
            else{
                self->cabtype=cab;
            }
            [self->def setObject:self->cabtype forKey:@"cabtype"];
            [self->def setObject:@"1" forKey:@"UserLogin"];
            [self->def synchronize];
            NSString *returnstring=[responseDictionary valueForKey:@"isError"];
            BOOL error1=[returnstring boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error1==0) {
                    
                    if (self->check==1) {
                        [self showIssues];
                    }
                    else if (self->check==2){
                        [self postmethod];
                    }
                    else{
                        
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->_loadingView removeFromSuperview];
                    });
//                    NSString *error=[responseDictionary valueForKey:@"errorMessage"];
//                    NSLog(@"Login FAILURE");
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:error message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                    [alert show];
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
    }];
    [dataTask resume];

}
-(void)postmethod{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSString *comm=_txt.text;
    NSLog(@"Http Comm  :  %@",comm);
    if ([comm isEqualToString:@"Type your comments"]||[comm isEqual:@"Type your comments"]) {
        comm=@"";
    }
    else{
        
    }
    if (canid.length==0) {
        canid=@"";
    }
    else{
        
    }
   
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"postTripIssue"]]];
    
    NSDictionary *params = @{@"comments" : comm , @"reason" : canid, @"ride_id" : @"", @"status" : @"0", @"user_id" : [def valueForKey:@"driid"], @"admin_id" : @"string", @"created_date_time" : @"string" };
    
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
                if (error==0 || error==false) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:ISSSUC delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AlertViewController *alert1 = [storyboard instantiateViewControllerWithIdentifier:@"AlertViewController"];
                    [self presentViewController:alert1 animated:YES completion:nil];
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseDictionary valueForKey:@"errorMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                    [alert show];
                }
            });
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
                self->check=2;
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
    [dataTask resume];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _txt.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _txt.text=@"";
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txt resignFirstResponder];
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [_txt.text stringByReplacingCharactersInRange: range withString:text];
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
@end
