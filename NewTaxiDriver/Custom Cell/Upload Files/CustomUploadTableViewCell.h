//
//  CustomUploadTableViewCell.h
//  NewTaxiDriver
//
//  Created by Admin on 16/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUploadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_prof;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_edit;
@property (weak, nonatomic) IBOutlet UIButton *btn_del;

@end
