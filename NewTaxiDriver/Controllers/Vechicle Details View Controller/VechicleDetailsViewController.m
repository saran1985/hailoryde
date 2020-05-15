
//
//  VechicleDetailsViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "VechicleDetailsViewController.h"
#import "AlertViewController.h"
#import "Constant.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "CustomUploadTableViewCell.h"
#import "OtpViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface VechicleDetailsViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate,UIDocumentPickerDelegate>{
    NSUserDefaults *def;
    NSString *acc_tok,*exp_in,*tok_typ,*driid,*email,*ins_num,*lic_num,*mble,*model,*name,*plat_num,*encodedString,*filename,*image,*encodedStringg,*encodedString1,*encodedString2,*encodedString3,*encodedString4,*encodedString5,*encodedString6,*encodedString7,*encodedString8,*encodedString9,*encodedString10,*extension1,*extension2,*extension3,*extension4,*extension5;
    __weak IBOutlet UIView *view_upload;
    NSData *pngData1;
    __weak IBOutlet UIView *view_main;
    int val,check,cityval,cabval;
    NSMutableArray *imageData,*imageName,*imageString,*menuItemNameImage,*samimage,*imageString1;
    __weak IBOutlet UITableView *tablecity;
    __weak IBOutlet UIImageView *img;
    NSData *photoData;
    NSMutableArray *city;
    int imagepick,change;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *txt_make;
@property (weak, nonatomic) IBOutlet UITextField *txt_licnum;
@property (weak, nonatomic) IBOutlet UITextField *txt_insnum;
@property (weak, nonatomic) IBOutlet UITextField *txt_platenum;
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
@property (weak, nonatomic) IBOutlet UIView *view_upload;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UIView *view_uploadview;
@property (weak, nonatomic) IBOutlet UITextField *txt_hstnum;
@property (weak, nonatomic) IBOutlet UITextField *txt_city;
@property (weak, nonatomic) IBOutlet UITextField *txt_cabtype;
@property (weak, nonatomic) IBOutlet UITextField *txt_owner;
@property (weak, nonatomic) IBOutlet UITextField *txt_work;
@property (weak, nonatomic) IBOutlet UILabel *lbl_carcolor;
@property (weak, nonatomic) IBOutlet UITextField *txt_carcolor;
@property (weak, nonatomic) IBOutlet UILabel *lbl_hst;
@property (weak, nonatomic) IBOutlet UILabel *lbl_plate;

@end

@implementation VechicleDetailsViewController

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"samdoc" ofType:@"jpeg"];
    photoData = [NSData dataWithContentsOfFile:path];
    val=0;
    check=0;
    cityval=0;
    cabval=0;
    imageData=[[NSMutableArray alloc]init];
    imageName=[[NSMutableArray alloc]init];
    imageString =[[NSMutableArray alloc]init];
    imageString1 =[[NSMutableArray alloc]init];
    samimage=[[NSMutableArray alloc]init];
    encodedString1=@"";
    encodedString2=@"";
    encodedString3=@"";
    encodedString4=@"";
    encodedString5=@"";
//    _btn_submit.layer.cornerRadius=20;
//    _btn_submit.layer.borderColor=
    city=[[NSMutableArray alloc]init];
    tablecity.dataSource=self;
    tablecity.delegate=self;
    _table.dataSource=self;
    _table.delegate=self;
    _txt_make.delegate=self;
    _txt_insnum.delegate=self;
    _txt_licnum.delegate=self;
    _txt_platenum.delegate=self;
    _txt_hstnum.delegate=self;
    _txt_cabtype.delegate=self;
    _txt_city.delegate=self;
    _lbl_plate.hidden=YES;
    _lbl_hst.hidden=YES;
    _lbl_carcolor.hidden=YES;
    _txt_owner.userInteractionEnabled=NO;
    _txt_work.userInteractionEnabled=NO;
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    single.delegate=self;
    single.numberOfTapsRequired=1;
    single.numberOfTouchesRequired=1;
    change=0;
//    single.numberOfTapsRequired=2;
//    single.numberOfTouchesRequired=2;
    [_scroll addGestureRecognizer:single];
     [_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height*1.3)];
    
    
//    [imageData addObject:@"1"];
//    [imageData addObject:@"2"];
//    [imageData addObject:@"3"];
//
//    NSMutableArray *menuItemNameImage = [NSMutableArray array];
//    for (int i = 0 ; i != imageData.count ; i++) {
//        [menuItemNameImage addObject: @{
//                                        @"delete_status" : @""
//                                        ,   @"user_id" : @""
//                                        , @"value" : imageData[i]
//                                        }];
//    }
//    NSLog(@"Tot  :  %@", menuItemNameImage);
    [_txt_city setUserInteractionEnabled:NO];
    [_txt_cabtype setUserInteractionEnabled:NO];
    _view_upload.hidden=YES;
    _table.hidden=YES;
    tablecity.hidden=YES;
//    _view_uploadview.layer.cornerRadius=20;
    _view_uploadview.layer.borderColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
    _view_uploadview.layer.borderWidth=2;
//    _table.layer.borderWidth=2;
//    _table.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
//    _table.layer.cornerRadius=10;
//    _table.clipsToBounds=YES;
    [_scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height*2.0)];

//    [self check];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
- (IBAction)back_doAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)upload_docum_doAction:(id)sender {
    [self.view endEditing:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Select any one option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Documents",@"Cancel", nil];
    alert.tag=1;
    [alert show];
    
   
}
- (IBAction)submit_doAction:(id)sender {
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    if ([_txt_make.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MAKEVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_insnum.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:INSVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_licnum.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:LICVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_platenum.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PLATEVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_hstnum.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:HSTVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_carcolor.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CARVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_city.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CITYVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_cabtype.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CABVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (encodedString6.length==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:UPLPLATE delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (encodedString7.length==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:UPLHST delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (encodedString8.length==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:UPLCAR  delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (encodedString9.length==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:UPLWORK delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (encodedString10.length==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:UPLOWN delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
//    else if (imageName.count==0){
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please upload your documents" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
    else {
        [self postMethod];
    }
}
-(void)resign{
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)postMethod{
    encodedString1=[NSString stringWithFormat:@"%@.%@",encodedString6,extension1];
    encodedString2=[NSString stringWithFormat:@"%@.%@",encodedString7,extension2];
    encodedString3=[NSString stringWithFormat:@"%@.%@",encodedString8,extension3];
    encodedString4=[NSString stringWithFormat:@"%@.%@",encodedString9,extension4];
    encodedString5=[NSString stringWithFormat:@"%@.%@",encodedString10,extension5];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
   _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
//    [imageString addObject:@"111"];
//    [imageName addObject:@"11"];
//    [imageData addObject:@"111111"];
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"register"]]];


    
    NSLog(@"Tot  Count  :  %lu",(unsigned long)imageString.count);
    
    
    NSString *jsonString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *e1;
    NSMutableArray *jsonList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e1];
    NSLog(@"jsonList: %@", jsonList);


    
    
    menuItemNameImage = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < imageString.count ; i++) {
        [menuItemNameImage addObject: @{
                                        @"delete_status" : @""
                                        ,   @"user_id" : @""
                                        , @"value" : imageString[i]
                                        }];
        NSLog(@"Arr Img  :  %@", menuItemNameImage);
    }
    if (menuItemNameImage.count==0) {
        [menuItemNameImage addObject: @{
                                        @"delete_status" : @""
                                        ,   @"user_id" : @""
                                        , @"value" : @""
                                        }];
    }
    else{
        
    }
    NSLog(@"Tot  :  %@", menuItemNameImage);
    NSString *platform=[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    NSDictionary *params = @{
                             @"driver_profile" : @{@"name" : _name, @"password" : _pwd, @"email" : _email, @"mobile" : _mble,@"user_type" : @"1" ,@"profile_image" : _image, @"rating" : @"0", @"device_id" : [def valueForKey:@"fcm"], @"delete_status" : @"string", @"verify_status" : @"string", @"account_status" : @"string",@"platform": platform },
                             @"driver_details" : @{@"insurance_number": _txt_insnum.text, @"license_number": _txt_licnum.text, @"model": _txt_make.text,@"plate_number": _txt_platenum.text,@"rating": @"0", @"driver_id": @"",@"cab_type": _txt_cabtype.text,@"hst_number": _txt_hstnum.text,@"work_permit" : encodedString4,@"car_color" : _txt_carcolor.text,@"car_color_image" : encodedString3,@"hst_document":encodedString2,@"ownership_paper" : encodedString5,@"plate_number_file":encodedString1 },
//                                 @"documents" : @{@"delete_status": @"",@"user_id": @"",@"value":@""}
                                 @"documents" : menuItemNameImage
                                 };
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Convert the String to Data
    NSData *data1 = [jsonInputString dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"Reg Val  :  %@",data1);
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil){
            NSLog(@"Estimate fare by distance");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                self->encodedString1=@"";
                self->encodedString2=@"";
                self->encodedString3=@"";
                self->encodedString4=@"";
                self->encodedString5=@"";
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
        NSLog(@"Login Dict  :  %@",responseDictionary);
        NSString *returnstring=[responseDictionary valueForKey:@"isError"];
        BOOL error1=[returnstring boolValue];
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                self->encodedString1=@"";
                self->encodedString2=@"";
                self->encodedString3=@"";
                self->encodedString4=@"";
                self->encodedString5=@"";
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
           
            if(error1==0)
            {
                NSUserDefaults *Def=[NSUserDefaults standardUserDefaults];
                [Def setObject:[responseDictionary valueForKey:@"response"] forKey:@"driid"];
                [Def synchronize];
                NSLog(@"Vechicle SUCCESS");
                [self login];
                
               
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                NSString *error=[responseDictionary valueForKey:@"errorMessage"];
                NSLog(@"Login FAILURE");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:error message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
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
        else if (httpResponse.statusCode == 400){
            NSString *error=[responseDictionary valueForKey:@"errorMessage"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
//                [self postMethod1];
            });
        }
        else
        {
            NSLog(@"Error  :  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *error=[responseDictionary valueForKey:@"errorMessage"];
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
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
        self->def=[NSUserDefaults standardUserDefaults];
        [self->def setObject:self->_pwd forKey:@"password"];
        [self->def setObject:self->_mble forKey:@"mobile"];
        [self->def synchronize];
    NSLog(@"MBE  :  %@\nPWD  :  %@",self->_mble,self->_pwd);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_loadingView removeFromSuperview];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtpViewController *alert = [storyboard instantiateViewControllerWithIdentifier:@"OtpViewController"];
        alert.mble=self->_mble;
        alert.pwd=self->_pwd;
    [self presentViewController:alert animated:YES completion:nil];
    });
}
-(void)postMethod1{
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
   _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    def=[NSUserDefaults standardUserDefaults];
    //    [imageString addObject:@"111"];
    //    [imageName addObject:@"11"];
    //    [imageData addObject:@"111111"];
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"register"]]];
    
    
    
    NSLog(@"Tot  Count  :  %lu",(unsigned long)imageString.count);
    
    
    NSString *jsonString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *e1;
    NSMutableArray *jsonList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e1];
    NSLog(@"jsonList: %@", jsonList);
    
    
    
    
    menuItemNameImage = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < imageString1.count ; i++) {
        [menuItemNameImage addObject: @{
                                        @"delete_status" : @""
                                        ,   @"user_id" : @""
                                        , @"value" : imageString1[i]
                                        }];
        NSLog(@"Arr Img  :  %@", menuItemNameImage);
    }
    if (menuItemNameImage.count==0) {
        [menuItemNameImage addObject: @{
                                        @"delete_status" : @""
                                        ,   @"user_id" : @""
                                        , @"value" : @""
                                        }];
    }
    else{
        
    }
    NSLog(@"Tot  :  %@", menuItemNameImage);
    
   
    NSDictionary *params = @{
                             @"driver_profile" : @{@"name" : _name, @"password" : _pwd, @"email" : _email, @"mobile" : _mble,@"user_type" : @"1" ,@"profile_image" : _image1, @"rating" : @"0", @"device_id" : [def valueForKey:@"fcm"], @"delete_status" : @"string", @"verify_status" : @"string", @"account_status" : @"string" },
                             @"driver_details" : @{@"insurance_number": _txt_insnum.text, @"license_number": _txt_licnum.text, @"model": _txt_make.text,@"plate_number": _txt_platenum.text,@"rating": @"0", @"driver_id": @"",@"cab_type": _txt_cabtype.text,@"hst_number": _txt_hstnum.text,@"work_permit" : encodedString4,@"car_color" : _txt_carcolor.text,@"car_color_image" : encodedString3,@"hst_document":encodedString2,@"ownership_paper" : encodedString5,@"plate_number_file":encodedString1 },
                             //                                 @"documents" : @{@"delete_status": @"",@"user_id": @"",@"value":@""}
                             @"documents" : menuItemNameImage
                             };
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    NSLog(@"Dict to Sting  :  %@",jsonInputString);
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Convert the String to Data
    NSData *data1 = [jsonInputString dataUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"Reg Val  :  %@",data1);
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
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
        NSLog(@"Login Dict  :  %@",responseDictionary);
        NSString *returnstring=[responseDictionary valueForKey:@"isError"];
        BOOL error1=[returnstring boolValue];
        if (data==nil || httpResponse.statusCode==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NETTITLE message:NETMSG delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        
        else if(httpResponse.statusCode == 200)
        {
            
            if(error1==0)
            {
                NSUserDefaults *Def=[NSUserDefaults standardUserDefaults];
                [Def setObject:[responseDictionary valueForKey:@"response"] forKey:@"driid"];
                [Def synchronize];
                NSLog(@"Vechicle SUCCESS");
                [self login];
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    NSString *error=[responseDictionary valueForKey:@"errorMessage"];
                    NSLog(@"Login FAILURE");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:error message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
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
        else if (httpResponse.statusCode == 400){
            NSString *error=[responseDictionary valueForKey:@"errorMessage"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
                [alert show];
            });
        }
        else
        {
            NSLog(@"Error  :  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *error=[responseDictionary valueForKey:@"errorMessage"];
                [self->_loadingView removeFromSuperview];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
//    NSString *imageNameRef = [imagePath lastPathComponent];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename1] : %@", [imageRep filename]);
        self->filename=[imageRep filename];
        NSLog(@"[imageRep filename2] : %@",  self->filename);
        self->def=[NSUserDefaults standardUserDefaults];
        [self->def setObject:self->filename forKey:@"file"];
        [self->def synchronize];
        if (self->change==2) {
            
        if (self->imagepick==1) {
//            self->encodedString1 = [self base64forData:self->pngData1];
            self->_lbl_plate.hidden=NO;
            if (self->filename.length==0||[self->filename isEqual:@"(null)"]) {
                NSLog(@"FILE IS EMPTY");
                self->_lbl_plate.text=[NSString stringWithFormat:@"image1.jpg"];
            }
            else{
                NSLog(@"FILE IS NOT EMPTY");
                self->_lbl_plate.text=[NSString stringWithFormat:@"%@",self->filename];
            }
        }
        else if (self->imagepick==2) {
//            self->encodedString2 = [self base64forData:self->pngData1];
            self->_lbl_hst.hidden=NO;
            self->_lbl_hst.text=[NSString stringWithFormat:@"%@",self->filename];
            if (self->filename.length==0||[self->filename isEqual:@"(null)"]) {
                NSLog(@"FILE IS EMPTY");
                self->_lbl_hst.text=[NSString stringWithFormat:@"image2.jpg"];
            }
            else{
                NSLog(@"FILE IS NOT EMPTY");
                self->_lbl_hst.text=[NSString stringWithFormat:@"%@",self->filename];
            }
        }
        else if (self->imagepick==3) {
//            self->encodedString3 = [self base64forData:self->pngData1];
            self->_lbl_carcolor.hidden=NO;
            self->_lbl_carcolor.text=[NSString stringWithFormat:@"%@",self->filename];
            if (self->filename.length==0||[self->filename isEqual:@"(null)"]) {
                NSLog(@"FILE IS EMPTY");
                self->_lbl_carcolor.text=[NSString stringWithFormat:@"image3.jpg"];
            }
            else{
                NSLog(@"FILE IS NOT EMPTY");
                self->_lbl_carcolor.text=[NSString stringWithFormat:@"%@",self->filename];
            }
        }
        else if (self->imagepick==4) {
//            self->encodedString4 = [self base64forData:self->pngData1];
            self->_txt_work.text=[NSString stringWithFormat:@"%@",self->filename];
            if (self->filename.length==0||[self->filename isEqual:@"(null)"]) {
                NSLog(@"FILE IS EMPTY");
                self->_txt_work.text=[NSString stringWithFormat:@"image4.jpg"];
            }
            else{
                NSLog(@"FILE IS NOT EMPTY");
                self->_txt_work.text=[NSString stringWithFormat:@"%@",self->filename];
            }
        }
        else if (self->imagepick==5) {
//            self->encodedString5 = [self base64forData:self->pngData1];
            self->_txt_owner.text=[NSString stringWithFormat:@"%@",self->filename];
            if (self->filename.length==0||[self->filename isEqual:@"(null)"]) {
                NSLog(@"FILE IS EMPTY");
                self->_txt_owner.text=[NSString stringWithFormat:@"image5.jpg"];
            }
            else{
                NSLog(@"FILE IS NOT EMPTY");
                self->_txt_owner.text=[NSString stringWithFormat:@"%@",self->filename];
            }
        }
        else{
            
        }
        }
        else{
            
        }
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    NSData *pngData2 = UIImageJPEGRepresentation(chosenImage,0);
    NSInteger imageSize1   = pngData2.length;
    NSLog(@"size of image in KB: %f ", imageSize1/1024.0);
    pngData1 = UIImageJPEGRepresentation(chosenImage,1.0);
    NSInteger imageSize   = pngData1.length;
    NSLog(@"size of image in KB: %f ", imageSize/1024.0);
    NSLog(@"Img Data  :  %@",pngData1);
    val=val+1;
//    NSString *name=[NSString stringWithFormat:@"IMG_%d",val];
//    [imageName addObject:name];
    
//    [imageData addObject:pngData1];
//    [samimage addObject:pngData1];
    // NSData *pngData2 = UIImagePNGRepresentation(chosenImage);
    
    NSLog(@"IMAGE NAME : %@",chosenImage);
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {

        UIImageWriteToSavedPhotosAlbum(chosenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    encodedString = [self base64forData:pngData1];
    encodedStringg = [[self base64forData:pngData1] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    encodedString=[NSString stringWithFormat:@"%@.JPG",encodedString];
    NSLog(@"Img Str  :  %@",encodedString);
//    [imageString addObject:encodedString];
//    [imageString1 addObject:encodedStringg];
    if (self->imagepick==1) {
        self->extension1=@"jpg";
        self->encodedString6 = [self base64forData:self->pngData1];
    }
    else if (self->imagepick==2) {
        self->extension2=@"jpg";
        self->encodedString7 = [self base64forData:self->pngData1];
    }
    else if (self->imagepick==3) {
        self->extension3=@"jpg";
        self->encodedString8 = [self base64forData:self->pngData1];
    }
    else if (self->imagepick==4) {
        self->extension4=@"jpg";
        self->encodedString9 = [self base64forData:self->pngData1];
    }
    else if (self->imagepick==5) {
        self->extension5=@"jpg";
        self->encodedString10 = [self base64forData:self->pngData1];
    }
    else{
        
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
//    _view_upload.frame=CGRectMake(_txt_make.frame.origin.x,_lbl.frame.origin.y+23, self.txt_make.frame.size.width, self.table.frame.size.height);
//    [_scroll addSubview:_view_upload];
    _view_upload.hidden=NO;
    _table.hidden=NO;
//    def=[NSUserDefaults standardUserDefaults];
//    NSLog(@"FIle name  :  %@",[def valueForKey:@"file"]);
//    [self->imageName addObject:[def valueForKey:@"file"]];
//    [def removeObjectForKey:@"file"];
//    [def synchronize];
//    [_table reloadData];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"Contextinfo%@",contextInfo);
    if (change==1) {
        
    
    if (self->imagepick==1) {
//        self->encodedString1 = [self base64forData:self->pngData1];
        self->_lbl_plate.hidden=NO;
        self->_lbl_plate.text=[NSString stringWithFormat:@"image1.jpg"];
    }
    else if (self->imagepick==2) {
//        self->encodedString2 = [self base64forData:self->pngData1];
        self->_lbl_hst.hidden=NO;
        self->_lbl_hst.text=[NSString stringWithFormat:@"%@",@"image2.jpg"];
    }
    else if (self->imagepick==3) {
//        self->encodedString3 = [self base64forData:self->pngData1];
        self->_lbl_carcolor.hidden=NO;
        self->_lbl_carcolor.text=[NSString stringWithFormat:@"%@",@"image3.jpg"];
    }
    else if (self->imagepick==4) {
//        self->encodedString4 = [self base64forData:self->pngData1];
        _txt_work.text=[NSString stringWithFormat:@"%@",@"image4.jpg"];
    }
    else if (self->imagepick==5) {
//        self->encodedString5 = [self base64forData:self->pngData1];
        _txt_owner.text=[NSString stringWithFormat:@"%@",@"image5.jpg"];
    }
    else{
        
    }
    }
    else{
        
    }
}
- (NSString*)base64forData:(NSData*)theData {
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return city.count;
    }
    else {
    return imageName.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tablecity dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        cell.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        tablecity.separatorColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.5];
        cell.textLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@",[city objectAtIndex:indexPath.row]];
        return cell;
    }
    else{
    NSString *cellIdentifier=@"CustomUploadTableViewCell";
    CustomUploadTableViewCell *cell=[_table dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle=UITableViewStylePlain;
    cell.lbl_name.text =  [NSString stringWithFormat:@"%@",[imageName objectAtIndex:indexPath.row]];
    cell.img_prof.image = [UIImage imageWithData:[samimage objectAtIndex:indexPath.row]];
    cell.btn_edit.tag=indexPath.row;
    [cell.btn_edit addTarget:self action:@selector(editCell:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_del.tag=indexPath.row;
    [cell.btn_edit addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        [imageName removeObjectAtIndex:indexPath.row];
        [samimage removeObjectAtIndex:indexPath.row];
        [imageData removeObjectAtIndex:indexPath.row];
        if (imageName.count==0) {
//            [_view_upload removeFromSuperview];
            _view_upload.hidden=YES;
            _table.hidden=YES;
            val=0;
        }
        else{
            
        }
//        [_table reloadData];
        
    }
}
-(void)editCell:(id)sender{
    
}
-(void)delCell:(id)sender{
    
}
-(void)check{
    // Two simple dictionaries of data
    NSDictionary *someDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"value", @"key", nil];
    NSDictionary *someDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"2value", @"2key", nil];
    // Putting them both into an array
    NSArray *somearray = [NSArray arrayWithObjects:someDict,someDict2, nil];
    NSLog(@"Arr val  :  %@",somearray);
    // Dictionary with array and another key-value pair
    NSDictionary *final = [NSDictionary dictionaryWithObjectsAndKeys:
                           somearray, @"myarray",
                           @"avalue", @"for a key", nil];
//    NSDictionary *dd=[NSDictionary dictionaryWithValuesForKeys:final];
    NSLog(@"Dic val  :  %@",final);
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:final options:0 error:&error];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:@"http://localhost:3000/events"]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            change=1;
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
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:ALERTVAL message:@"Dear Driver Please allow to access camera" delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
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
            change=2;
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.allowsEditing=YES;
            imagepicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
        else if (buttonIndex==2){
            //BOOL myAppInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Files"]];
//            NSLog(@"Check = %d",myAppInstalled);
            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.content"] inMode:UIDocumentPickerModeImport];    //public.composite-content
            documentPicker.delegate = self;
            [documentPicker setModalPresentationStyle:UIModalPresentationFormSheet];
            [self presentViewController:documentPicker animated:YES completion:nil];
        }
        else{
            
        }
    }
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSLog(@"controller.documentPickerMode = %lu", (unsigned long)controller.documentPickerMode);
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSLog(@"Success");
        NSLog(@"url = %@", url);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"last path: %@", [url lastPathComponent]);
            NSString *list = [url lastPathComponent];
            NSArray *listItems = [list componentsSeparatedByString:@"."];
//            NSString *str1=[listItems objectAtIndex:0];
            NSString *str2=[listItems objectAtIndex:1];
            //             self->img.image=[UIImage imageNamed:@"1388239106989.jpg"];
            NSData *imageData1 = [NSData dataWithContentsOfURL:url];
//             self->img.image=[UIImage imageWithData:imageData1];
            NSLog(@"file data = %@", imageData1);
            NSString *str = [[NSString alloc] initWithData:imageData1 encoding:NSASCIIStringEncoding];
            NSLog(@"Str  :  %@",str);
            
             NSString *encodedStringg = [self base64forData:imageData1];
            encodedStringg=[NSString stringWithFormat:@"%@.%@",encodedStringg,str2];
             NSLog(@"Encoded Str  :   %@", encodedStringg);
//            [self->imageString addObject:encodedStringg];
//            [self->imageString1 addObject:encodedStringg];
            
            // Decoded NSString from the NSData
            
            self->val=self->val+1;
//            NSString *name=[NSString stringWithFormat:@"IMG_%d",self->val];
//            [self->imageName addObject:name];
//            [self->imageName addObject:[url lastPathComponent]];
//            [self->imageData addObject:imageData1];
            if ([str2 isEqualToString:@"jpeg"]||[str2 isEqualToString:@"jpg"]||[str2 isEqualToString:@"png"]||[str2 isEqual:@"jpeg"]||[str2 isEqual:@"jpg"]||[str2 isEqual:@"png"]) {
//                [self->samimage addObject:imageData1];
            }
            else{
//                [self->samimage addObject:self->photoData];
            }
//            self->img.image=[UIImage imageWithData:imageData];
//            self->_view_upload.frame=CGRectMake(self->_txt_make.frame.origin.x,self->_lbl.frame.origin.y+30, self.txt_make.frame.size.width, self.table.frame.size.height);
//            [self->_scroll addSubview:self->_view_upload];
            self->_view_upload.hidden=NO;
            self->_table.hidden=NO;
//            [self->_table reloadData];
            if (self->imagepick==1) {
                self->extension1=str2;
                self->encodedString6 = [self base64forData:imageData1];
                self->_lbl_plate.hidden=NO;
                self->_lbl_plate.text=[NSString stringWithFormat:@"%@",[url lastPathComponent]];
            }
            else if (self->imagepick==2) {
                self->extension2=str2;
                self->encodedString7 = [self base64forData:imageData1];
                self->_lbl_hst.hidden=NO;
                self->_lbl_hst.text=[NSString stringWithFormat:@"%@",[url lastPathComponent]];
            }
            else if (self->imagepick==3) {
                self->extension3=str2;
                self->encodedString8 = [self base64forData:imageData1];
                self->_lbl_carcolor.hidden=NO;
                self->_lbl_carcolor.text=[NSString stringWithFormat:@"%@",[url lastPathComponent]];
            }
            else if (self->imagepick==4) {
                self->extension4=str2;
                self->encodedString9 = [self base64forData:imageData1];
                self->_txt_work.text=[NSString stringWithFormat:@"%@",[url lastPathComponent]];
            }
            else if (self->imagepick==5) {
                self->extension5=str2;
                self->encodedString10 = [self base64forData:imageData1];
                 self->_txt_owner.text=[NSString stringWithFormat:@"%@",[url lastPathComponent]];
            }
            else{
                
            }
        });
    }
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    
    NSLog(@"documentPickerWasCancelled");
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch ([textField tag]) {
        case 1:
            [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
            
            break;
        case 2:
            [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
            
        case 3:
            [_scroll setContentOffset:CGPointMake(0, 100) animated:YES];
            break;
            
        case 4:
            [_scroll setContentOffset:CGPointMake(0, 130) animated:YES];
            break;
            
        case 5:
            [_scroll setContentOffset:CGPointMake(0, 160) animated:YES];
            break;
        case 6:
            [_scroll setContentOffset:CGPointMake(0, 190) animated:YES];
            break;
        default:
            break;
    }
}
- (IBAction)city_doAction:(id)sender {
    if (cityval==0) {
        cityval=1;
        [self city];
    }
    else{
        cityval=0;
        tablecity.hidden=YES;
    }
}
- (IBAction)cab_doActon:(id)sender {
     if ([_txt_city.text isEqual:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CITYVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
     else{
         if (cabval==0) {
             cabval=1;
         [self cabtype];
         }
         else{
             cabval=0;
             tablecity.hidden=YES;
         }
     }
}
-(void)cabtype{
    check=2;
    city=[[NSMutableArray alloc]init];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    NSLog(@"Text Val  :  %@",_txt_city.text);
    NSString *dest = [_txt_city.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?city=%@",BASE_URL,@"getCabType",dest]];
    NSLog(@"Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    
    
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
                NSLog(@"Json2  :  %lu",(unsigned long)arr.count);
                for (int i=0; i<arr.count; i++) {
                    NSString *can=[[responseDictionary valueForKeyPath:@"response.typename"]objectAtIndex:i];
                    NSLog(@"Json Str  :  %@",can);
                    [self->city addObject:can];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    self->tablecity.hidden=NO;
                    [self->tablecity reloadData];
                    float height=44.0f*[self->city count];
                    self->tablecity.frame=CGRectMake(self->_txt_cabtype.frame.origin.x, self->_txt_cabtype.frame.origin.y+self->_txt_cabtype.frame.size.height+68, self->_txt_cabtype.frame.size.width,130);
                    self->tablecity.layer.borderColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
                    self->tablecity.layer.borderWidth=0.5;
                    [self.view addSubview:self->tablecity];
                    
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
-(void)city{
    check=1;
    city=[[NSMutableArray alloc]init];
    _loadingView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _loadingView.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loadingView.alpha=0.7;
    [self.view addSubview:_loadingView];
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"getCity"]];
    NSLog(@"Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    
    
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
                    [self->city addObject:can];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_loadingView removeFromSuperview];
                    self->tablecity.hidden=NO;
                    [self->tablecity reloadData];
                    float height=44.0f*[self->city count];
                    self->tablecity.frame=CGRectMake(self->_txt_city.frame.origin.x, self->_txt_city.frame.origin.y+self->_txt_city.frame.size.height+68, self->_txt_city.frame.size.width,130);
                    self->tablecity.layer.borderColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
                    self->tablecity.layer.borderWidth=0.5;
                    [self.view addSubview:self->tablecity];
                    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1){
        if (check==1) {
            _txt_city.text=[NSString stringWithFormat:@"%@",[city objectAtIndex:indexPath.row]];
            check=0;
        }
        else if (check==2){
            _txt_cabtype.text=[NSString stringWithFormat:@"%@",[city objectAtIndex:indexPath.row]];
            check=0;
        }
    }
    else{
        
    }
    tablecity.hidden=YES;
}
- (IBAction)owner_doAction:(id)sender {
    imagepick=5;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Select any one option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Documents",@"Cancel", nil];
    alert.tag=1;
    [alert show];
}
- (IBAction)work_doAction:(id)sender {
    imagepick=4;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Select any one option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Documents",@"Cancel", nil];
    alert.tag=1;
    [alert show];
}
- (IBAction)carcolor_doAction:(id)sender {
    imagepick=3;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Select any one option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Documents",@"Cancel", nil];
    alert.tag=1;
    [alert show];
}
- (IBAction)hst_doAction:(id)sender {
    imagepick=2;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Select any one option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Documents",@"Cancel", nil];
    alert.tag=1;
    [alert show];
}
- (IBAction)platenum_doAction:(id)sender {
    imagepick=1;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Select any one option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery",@"Documents",@"Cancel", nil];
    alert.tag=1;
    [alert show];
}
@end
