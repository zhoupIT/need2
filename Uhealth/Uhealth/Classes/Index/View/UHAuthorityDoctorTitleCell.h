//
//  UHAuthorityDoctorTitleCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHChannelDoctorModel;
@interface UHAuthorityDoctorTitleCell : UITableViewCell
@property (nonatomic,strong) UHChannelDoctorModel *model;
@property (nonatomic,copy) void (^imgClickBlock) (UIButton *btn);
@end