//
//  MenuViewPopup.m
//  Cabxy
//
//  Created by Immanuel Infant Raj.S on 7/27/15.
//  Copyright (c) 2015 Immanuel Infant Raj.S. All rights reserved.
//


#import "MenuViewPopup.h"



@implementation MenuViewPopup
@synthesize rootView, window;
@synthesize btn_ad,btn_fb,btn_chat,btn_home,btn_lang,btn_ride,btn_about,btn_logout,btn_complaints,btn_ridehistory;


+(MenuViewPopup *)sharedInstance{
    
    // the instance of this class is stored here
    static MenuViewPopup *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        
        myInstance = [[[self class] alloc] initWithView];
        
        
    }//End of if statement
    
    myInstance.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    myInstance.window.windowLevel = UIWindowLevelStatusBar;
    myInstance.window.hidden = YES;
    myInstance.window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.01];
    myInstance.onMenuItemSelect = nil;
    // gk
    [myInstance.window setFrame:CGRectMake(0, 64, myInstance.window.bounds.size.width, myInstance.bounds.size.height)];
    
    return myInstance;
}








-(id)initWithView{
    
    
    
       NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MenuViewPopup"
                                                     owner:nil
                                                   options:nil];
    
    if ([arrayOfViews count] < 1){
        
        return nil;
    }
    
    
    
    //[self addMeAsObserverMethod2];
    NSLog(@"initview");
    
    MenuViewPopup *newView = [arrayOfViews objectAtIndex:0];
    //[newView setFrame:frame];
    //newView.layer.cornerRadius = 10.0;
    //newView.clipsToBounds = YES;
    self = newView;
    
    
    return self;
    
    
}




- (void)didMenuViewPopupLoad:(UIView *)parentView andMenuItemSelect:(OnMenuItemSelect)menuItemSelect{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
     
    NSString *driverimage=[NSString stringWithFormat:@"http://tibstaxi.tibsurgicalshop.com/%@",[def valueForKey:@"driimg"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:driverimage]];
   
         [self downloadImageAtURL:driverimage withHandler:^(UIImage *image){
             if (image) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self->_img_profile.layer.cornerRadius = self->_img_profile.frame.size.width / 2;
                     self->_img_profile.clipsToBounds = YES;
                     self->_img_profile.image = image;
                      });
             }
         }];
//    if(imageData){
//        _img_profile.image=[UIImage imageWithData:imageData];
//    }
//    else{
//
//    }
    
    
     });
    _lbl_name.text=[NSString stringWithFormat:@"%@",[def valueForKey:@"driname"]];
    _lbl_mble.text=[NSString stringWithFormat:@"%@",[def valueForKey:@"drimbleno"]];
    self.rootView = parentView;
    self.onMenuItemSelect = menuItemSelect;
    
    NSLog(@"LOADING VIEW ");
    
    //Add alertview into transparent view to hide parent view interaction
    UIButton *transparentView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [transparentView setBackgroundColor:[UIColor clearColor]];
    [transparentView addTarget:self action:@selector(actionCancelMenuItem) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:self];
    //float x = (int)(transparentView.bounds.size.width - self.bounds.size.width);
    //float y = (int)(transparentView.bounds.size.height - self.bounds.size.height)>>1;
    
    
    // gk
    [self setFrame:CGRectMake(0, 60, self.bounds.size.width, self.bounds.size.height)];
    
    
    [self.window setFrame:parentView.frame];
    
    [self.window addSubview:transparentView];
    
    [self.window makeKeyAndVisible];
    
   
    
    
    
    
}
          - (void)downloadImageAtURL:(NSString *)imageURL withHandler:(void(^)(UIImage *image))handler
         {
             NSLog(@"Image String  : %@",imageURL);
             
             NSString *spaceStrObj=[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             
             NSURL *urlString = [NSURL URLWithString:spaceStrObj];
             
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             dispatch_async(queue, ^{
                 NSError *error = nil;
                 NSData *data = [NSData dataWithContentsOfURL:urlString options:NSDataReadingUncached error:&error];
                 if (!error) {
                     UIImage *downloadedImage = [UIImage imageWithData:data];
                     handler(downloadedImage); // pass back the image in a block
                 } else {
                     NSLog(@"%@", [error localizedDescription]);
                     handler(nil); // pass back nil in the block
                 }
             });
         }
-(void)actionCancelMenuItem{
    
    
    self.onMenuItemSelect(MENU_ITEM_CANCEL);
    [self didMenuViewPopupUnload];
    
}






-(void)didMenuViewPopupUnload{
    
    
    //gk
    [self.superview removeFromSuperview];
    // Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[self.rootView layer] addAnimation:animation forKey:@"layerAnimation"];
    self.window = nil;
    


    
}


- (IBAction)actionDidMenuItem:(id)sender {
  
    self.onMenuItemSelect((int)[(UIButton *)sender tag]);
    switch ([(UIButton *)sender tag]) {
        case 0:
         NSLog(@"case0");

            break;
        case 1:
        NSLog(@"case1");

            break;
        case 2:
         NSLog(@"case2");

            break;
        case 3:
        
         NSLog(@"case3");


            break;
        case 4:
        
        NSLog(@"case4");

            break;
        
        
        case 5:
        
        NSLog(@"case5");
            
            
            break;

            
         case 6:
            
            NSLog(@"case6");
            
            break;
        case 7:
            
            NSLog(@"case6");
            
            break;
        case 8:
            
            NSLog(@"case6");
            
            break;
            
        case 9:
            
            NSLog(@"case6");
            
            break;
            
        default:
            break;
    }
    
    [self didMenuViewPopupUnload];
}



















@end
