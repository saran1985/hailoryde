//
//  RegisterViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "RegisterViewController.h"
#import "VechicleDetailsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "Constant.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface RegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSString *encodedString,*encodedString1,*encodedString2,*encodedString3;
    IBOutlet UIView *view_main;
}
@property(strong,nonatomic)IBOutlet UIScrollView *scroll;
@property(strong,nonatomic)IBOutlet UIImageView *img_profile;
@property(strong,nonatomic)IBOutlet UITextField *txt_name;
@property(strong,nonatomic)IBOutlet UITextField *txt_mble;
@property(strong,nonatomic)IBOutlet UITextField *email;
@property(strong,nonatomic)IBOutlet UITextField *pwd;
@property(strong,nonatomic)IBOutlet UITextField *cnfpwd;
@property(strong,nonatomic)IBOutlet UIButton *btn_next;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, view_main.frame.size.height);
//    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
//        NSLog(@"HEIGHT : %f",statusBar.frame.size.height+view_main.frame.size.height);
//        _scroll.frame=CGRectMake(0, statusBar.frame.size.height+view_main.frame.size.height, self.view.frame.size.width, self.scroll.frame.size.height-statusBar.frame.size.height);
//    }
//    else{
//        
//    }
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
//    _btn_next.layer.cornerRadius=20;
//    _btn_next.layer.borderWidth=2;
    NSLog(@"IOS VER  :  %@",[[UIDevice currentDevice] systemVersion]);
    _txt_name.delegate=self;
    _txt_mble.delegate=self;
    _email.delegate=self;
    _pwd.delegate=self;
    _cnfpwd.delegate=self;
    encodedString=@"";
    encodedString1=@"";
    self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width / 2;
    self.img_profile.clipsToBounds = YES;
    
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    single.delegate=self;
    single.numberOfTapsRequired=1;
    single.numberOfTouchesRequired=1;
//    single.numberOfTapsRequired=2;
//    single.numberOfTouchesRequired=2;
    [_scroll addGestureRecognizer:single];
    
    
    NSString *jsonString1 = @"{\"ID\":{\"Content\":268,\"type\":\"text\"},\"ContractTemplateID\":{\"Content\":65,\"type\":\"text\"}}";
    NSData *data = [jsonString1 dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"JSON : %@",json);
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
//    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    encodedString=@"";
    encodedString1=@"";
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
-(IBAction)back_doAction:(id)sender{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)next_doAction:(id)sender{
    [self.view endEditing:YES];
    BOOL nameValidation=[self isValidName:_txt_name.text];
    BOOL emailValidation=[self validateEmailWithString:_email.text];
    BOOL numValidation=[self mbleNumVal:_txt_mble.text];
    if (encodedString2.length==0||encodedString3.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PROFIMGVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_txt_name.text isEqual:@""]) {
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
    else if (_txt_mble.text.length<10 || _txt_mble.text.length>10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MBLERANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!numValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:MBLENUMVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_email.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:EMAILVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (!emailValidation){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:EMAILSTRVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_pwd.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PWDVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (_pwd.text.length<6){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PWDRANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if ([_cnfpwd.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CNFPWDVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (_cnfpwd.text.length<6){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:CNFPWDRANVAL delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else if (![_pwd.text isEqual:_cnfpwd.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:PWDMISMATCH delegate:self cancelButtonTitle:nil otherButtonTitles:OKBUT, nil];
        [alert show];
    }
    else{
        encodedString=encodedString2;
        encodedString1=encodedString3;
        [self postMethod];
    
    }
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
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
- (IBAction)profile_doAction:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Add Profile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose from gallery",@"Cancel", nil];
    alert.delegate=self;
    alert.tag=1;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
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
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imagePath lastPathComponent];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    NSData *pngData2 = UIImagePNGRepresentation(chosenImage);
    NSData *pngData1 = UIImageJPEGRepresentation(chosenImage,1.0);
    NSLog(@"IMAGE NAME : %@",imageName);
    
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(chosenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
        self.img_profile.image = chosenImage;
        encodedString2 = [self base64forData:pngData1];
    encodedString3 = [[self base64forData:pngData1] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSLog(@"Str  :  %@",encodedString);
        [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
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

-(void)postMethod{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:_txt_mble.text forKey:@"mobile"];
    [def setObject:_pwd.text forKey:@"password"];
    [def synchronize];
    encodedString=[NSString stringWithFormat:@"%@.JPG",encodedString];
    encodedString1=[NSString stringWithFormat:@"%@.JPG",encodedString1];
    NSLog(@"Image  :  %@",encodedString);
    [self.view endEditing:YES];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                          VechicleDetailsViewController *vechicle = [storyboard instantiateViewControllerWithIdentifier:@"VechicleDetailsViewController"];
                                          vechicle.image=self->encodedString;
                                          vechicle.image1=self->encodedString1;
                                          vechicle.name=self->_txt_name.text;
                                          vechicle.mble=self->_txt_mble.text;
                                          vechicle.email=self->_email.text;
                                          vechicle.pwd=self->_pwd.text;
                                          [self presentViewController:vechicle animated:YES completion:nil];
                                          
                                      });
    
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
            
        case 5:
            [_scroll setContentOffset:CGPointMake(0, 200) animated:YES];
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
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.tag==2){
//        NSString *filter = @"##########";
//
//        if(!filter) return YES; // No filter provided, allow anything
//
//        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//        if(range.length == 1 && // Only do for single deletes
//           string.length < range.length &&
//           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
//        {
//            // Something was deleted.  Delete past the previous number
//            NSInteger location = changedString.length-1;
//            if(location > 0)
//            {
//                for(; location > 0; location--)
//                {
//                    if(isdigit([changedString characterAtIndex:location]))
//                    {
//                        break;
//                    }
//                }
//                changedString = [changedString substringToIndex:location];
//            }
//        }
//
//        textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
//    }
//    return NO;
//}
//NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter)
//{
//    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
//    char outputString[([filter length])];
//    BOOL done = NO;
//
//    while(onFilter < [filter length] && !done)
//    {
//        char filterChar = [filter characterAtIndex:onFilter];
//        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
//        switch (filterChar) {
//            case '#':
//                if(originalChar=='\0')
//                {
//                    // We have no more input numbers for the filter.  We're done.
//                    done = YES;
//                    break;
//                }
//                if(isdigit(originalChar))
//                {
//                    outputString[onOutput] = originalChar;
//                    onOriginal++;
//                    onFilter++;
//                    onOutput++;
//                }
//                else
//                {
//                    onOriginal++;
//                }
//                break;
//            default:
//                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
//                outputString[onOutput] = filterChar;
//                onOutput++;
//                onFilter++;
//                if(originalChar == filterChar)
//                    onOriginal++;
//                break;
//        }
//    }
//    outputString[onOutput] = '\0'; // Cap the output string
//    return [NSString stringWithUTF8String:outputString];
//}
-(UIImage *)fireYourImageForCompression:(UIImage *)imgComing{
    
    NSData *dataImgBefore   = [[NSData alloc] initWithData:UIImageJPEGRepresentation((imgComing), 1.0)];//.1 BEFORE COMPRESSION
    int imageSizeBefore     = (int)dataImgBefore.length;
    
    
    NSLog(@"SIZE OF IMAGE: %i ", imageSizeBefore);
    NSLog(@"SIZE OF IMAGE in Kb: %i ", imageSizeBefore/1024);
    
    
    
    NSData *dataCompressedImage = UIImageJPEGRepresentation(imgComing, .1); //.1 is low quality
    int sizeCompressedImage     = (int)dataCompressedImage.length;
    NSLog(@"SIZE AFTER COMPRESSION  OF IMAGE: %i ", sizeCompressedImage);
    NSLog(@"SIZE AFTER COMPRESSION OF IMAGE in Kb: %i ", sizeCompressedImage/1024); //AFTER
    
    //now change your image from compressed data
    imgComing = [UIImage imageWithData:dataCompressedImage];
    
    
    return imgComing;}

@end
