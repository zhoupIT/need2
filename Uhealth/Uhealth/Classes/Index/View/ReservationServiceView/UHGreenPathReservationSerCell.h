//
//  UHGreenPathReservationSerCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UHMedicalCityServiceModel;
@interface UHGreenPathReservationSerCell : UITableViewCell
@property (nonatomic,strong) UHMedicalCityServiceModel *model;
//选中服务
@property (nonatomic,copy) void (^selServiceBlock) (BOOL sel);
@end

NS_ASSUME_NONNULL_END
