//
//  CommonReportViewController.m
//  NewTaxiDriver
//
//  Created by Admin on 07/08/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "CommonReportViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface CommonReportViewController ()
@property (weak, nonatomic) IBOutlet UIView *view_amt;
@property (weak, nonatomic) IBOutlet UIView *view_trip;
@property (weak, nonatomic) IBOutlet UIView *view_hours;
@property (weak, nonatomic) IBOutlet UILabel *lbl_hours;
@property (weak, nonatomic) IBOutlet UILabel *lbl_trips;
@property (weak, nonatomic) IBOutlet UILabel *lbl_amt;
@property (weak, nonatomic) IBOutlet UILabel *lbl_heading;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property (weak, nonatomic) IBOutlet UIView *view_main;

@end

@implementation CommonReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Fabric with:@[[Crashlytics class]]];
//    UIView *statusBar=[[UIApplication sharedApplication] valueForKey:@"statusBar"];
//    _view_main.frame=CGRectMake(0, statusBar.frame.size.height, self.view.frame.size.width, _view_main.frame.size.height);
//    
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    
    self.manWalkingImageView.animatedImage = manWalkingImage;
    _lbl_heading.text=[NSString stringWithFormat:@"%@",_heading];
    NSLog(@"Val : %@",_trip);
    _lbl_trips.text=[NSString stringWithFormat:@"%@",_trip];
    _lbl_hours.text=[NSString stringWithFormat:@"%@ hrs",_hour];
    _lbl_amt.text=[NSString stringWithFormat:@"CAD %@",_amount];
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
- (IBAction)back_doAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
