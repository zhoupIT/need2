//
//  UHReservationCityListController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger,ZPEnterType) {
    ZPEnterTypeCity,
    ZPEnterTypeService
};
@class UHReservationCityModel,UHCityServicesModel;
@interface UHReservationCityListController : UIViewController
@property (nonatomic,copy) void (^selectedCityBlock) (UHReservationCityModel *model);
@property (nonatomic,copy) void (^selectedServiceBlock) (UHCityServicesModel *model);
@property (nonatomic,assign) ZPEnterType type;

@property (nonatomic,copy) NSString *ID;


//已经选择的model
//城市模型
@property (nonatomic,strong) UHReservationCityModel *cityModelSel;
//服务模型
@property (nonatomic,strong) UHCityServicesModel *serviceModelSel;
@end
