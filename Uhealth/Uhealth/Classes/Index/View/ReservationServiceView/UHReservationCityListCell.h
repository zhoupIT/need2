//
//  UHReservationCityListCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHReservationCityModel,UHCityServicesModel;
@interface UHReservationCityListCell : UITableViewCell
@property (nonatomic,strong) UHReservationCityModel *model;
@property (nonatomic,strong) UHCityServicesModel *servicesModel;
@property (nonatomic,copy) void (^didClickBlock) (UIButton *btn);
@end
