//
//  UHReservationCheckOutController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UHReservationCityModel.h"
#import "UHCityServicesModel.h"
#import "UHPatientListModel.h"
#import "UHHospitalModel.h"
#import "UHMedicalCityServiceModel.h"
@interface UHReservationCheckOutController : UIViewController


//就医城市 模型
@property (nonatomic,strong) UHReservationCityModel *cityModel;
//服务类型 模型
@property (nonatomic,strong) UHMedicalCityServiceModel *serviceModel;
//就医人 模型
@property (nonatomic,strong) UHPatientListModel *patientModel;
//医院 模型
@property (nonatomic,strong) UHHospitalModel *hospitalModel;

@property (nonatomic,copy) NSString *phoneValue;

@property (nonatomic,copy) NSString *noti;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *type;
//合计
@property (nonatomic,copy) NSString *originProductAmountTotal;
//优惠金额
@property (nonatomic,copy) NSString *reducedPrice;
//实付款
@property (nonatomic,copy) NSString *orderAmountTotal;
//运费
@property (nonatomic,copy) NSString *logisticsFee;
@end
