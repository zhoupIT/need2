//
//  UHGreenPathHospitalCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UHHospitalModel;
@interface UHGreenPathHospitalCell : UITableViewCell
//选中医院
@property (nonatomic,copy) void (^selHospitalBlock) (BOOL sel);
@property (nonatomic,strong) UHHospitalModel *model;
@end

NS_ASSUME_NONNULL_END
