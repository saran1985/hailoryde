//
//  ViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ViewController ()
@property(strong,nonatomic)IBOutlet UIButton *btn_start;
@property(strong,nonatomic)IBOutlet UIButton *btn_register;
@property(strong,nonatomic)IBOutlet UIButton *btn_login;
@property(strong,nonatomic)IBOutlet UILabel *lbl_alert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
    _btn_register.layer.borderWidth=2;
_btn_register.layer.borderColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;//    _btn_register.layer.cornerRadius=20;
    
//    _btn_login.layer.borderWidth=2;
//    _btn_login.layer.borderColor=[[UIColor colorWithRed:242.0/255.0 green:195.0/255.0 blue:31.0/255.0 alpha:1.0] CGColor];
//    _btn_login.layer.cornerRadius=20;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [Fabric with:@[[Crashlytics class]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)stsrt_doAction:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self presentViewController:view animated:YES completion:nil];
}
-(IBAction)login_doAction:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}
-(IBAction)register_doAction:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:view animated:YES completion:nil];
    
}

@end
