//
//  UHGreenPathHospitalController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UHHospitalModel;
@interface UHGreenPathHospitalController : UIViewController
@property (nonatomic,copy) NSString *cityServiceId;
@property (nonatomic,copy) void (^selHospitalBlock) (UHHospitalModel *model);
//已经选择的model
//医院模型
@property (nonatomic,strong) UHHospitalModel *hospitalModelSel;
@end

NS_ASSUME_NONNULL_END
