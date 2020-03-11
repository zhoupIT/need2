//
//  UHGreenPathReservationSerController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UHMedicalCityServiceModel;
@interface UHGreenPathReservationSerController : UIViewController
//城市id
@property (nonatomic,copy) NSString *cityID;
@property (nonatomic,copy) void (^selectedServiceBlock) (UHMedicalCityServiceModel *model);
//选中的城市服务
@property (nonatomic,strong) UHMedicalCityServiceModel *serviceModelSel;
@end

NS_ASSUME_NONNULL_END
