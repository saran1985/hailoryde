//
//  MenuViewPopup.h
//  Cabxy
//
//  Created by Immanuel Infant Raj.S on 7/27/15.
//  Copyright (c) 2015 Immanuel Infant Raj.S. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol MenuDelegate <NSObject>



@end


typedef enum MenuItemSelect{
    
    MENU_ITEM_HOME,
    MENU_ITEM_RIDE_HISTORY,
    MENU_ITEM_RIDE,
    MENU_ITEM_COMPLAINTS,
    MENU_ITEM_CHAT_BOX,
    MENU_ITEM_LANG,
    MENU_ITEM_ABOUT,
    MENU_ITEM_ADVERTISMENT,
    MENU_ITEM_FACEBOOK,
    MENU_ITEM_LOGOUT,
    MENU_ITEM_CANCEL
    
}MenuItemSelect;





typedef void (^OnMenuItemSelect)(MenuItemSelect);

@interface MenuViewPopup : UIView

@property (nonatomic, strong) id observer;

@property(strong, nonatomic)NSString *stname;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *rootView;
@property (copy, nonatomic) OnMenuItemSelect onMenuItemSelect;
@property(strong,nonatomic)id<MenuDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_ride;
@property (weak, nonatomic) IBOutlet UIButton *btn_complaints;
@property (weak, nonatomic) IBOutlet UIButton *btn_lang;
@property (weak, nonatomic) IBOutlet UIButton *btn_about;
@property (weak, nonatomic) IBOutlet UIButton *btn_ad;
@property (weak, nonatomic) IBOutlet UIButton *btn_chat;
@property (weak, nonatomic) IBOutlet UIButton *btn_fb;
@property (weak, nonatomic) IBOutlet UIButton *btn_logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_home;
@property (weak, nonatomic) IBOutlet UIButton *btn_ridehistory;

+(MenuViewPopup *)sharedInstance;
-(id)initWithView;
- (void)didMenuViewPopupLoad:(UIView *)parentView andMenuItemSelect:(OnMenuItemSelect)menuItemSelect;
-(void)didMenuViewPopupUnload;
- (IBAction)actionDidMenuItem:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@property (weak, nonatomic) IBOutlet UILabel *lbl_mble;
@property (weak, nonatomic) IBOutlet UIImageView *img_profile;




@end
