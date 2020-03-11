//
//  UHNurseCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCabinDetailModel,UHNurseModel;
@interface UHNurseCell : UITableViewCell
@property (nonatomic,strong) UHCabinDetailModel *model;
@property (nonatomic,copy) void (^contactNurseBlock) (UHNurseModel *model);
@end
