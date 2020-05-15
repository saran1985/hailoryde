//
//  TrackViewController.h
//  Driver
//
//  Created by Admin on 21/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackViewController : UIViewController
@property(strong,nonatomic)NSString *rideid;
@property(strong,nonatomic)NSString *basedist;
@property(strong,nonatomic)NSString *basefare;
@property(strong,nonatomic)NSString *cabfare;
@property(strong,nonatomic)NSString *cabtype;
@property(strong,nonatomic)NSString *bkdatetime;
@property(strong,nonatomic)NSString *fromlat;
@property(strong,nonatomic)NSString *fromlon;
@property(strong,nonatomic)NSString *fromloc;
@property(strong,nonatomic)NSString *tolat;
@property(strong,nonatomic)NSString *tolon;
@property(strong,nonatomic)NSString *toloc;
@property(strong,nonatomic)NSString *paysta;
@property(strong,nonatomic)NSString *paytype;
@property(strong,nonatomic)NSString *ridestatus;
@property(strong,nonatomic)NSString *totdist;
@property(strong,nonatomic)NSString *tottime;
@property(strong,nonatomic)NSString *userid;
@property(strong,nonatomic)NSString *cusname;
@property(strong,nonatomic)NSString *cusmble;
@property(nonatomic)NSInteger notifyid;
@property(strong,nonatomic)NSData *imgdata;
@end
