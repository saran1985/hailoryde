//
//  MessageViewController.m
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MessageViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface MessageViewController ()
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *manWalkingImageView;
@property(strong,nonatomic)IBOutlet UITableView *table;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FLAnimatedImage *manWalkingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ripple1" ofType:@"gif"]]];
    self.manWalkingImageView.animatedImage = manWalkingImage;
    _table.hidden=YES;
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
-(IBAction)back_doAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
