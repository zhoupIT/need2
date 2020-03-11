//
//  UHBuaCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHBloodPressureModel,UHNiBPModel;
@interface UHBuaCell : UITableViewCell
@property (nonatomic,strong) UHBloodPressureModel *model;
//是否是企业用户
@property (nonatomic,assign) BOOL isCompany;
@property (nonatomic,strong) UHNiBPModel *uaModel;
@property (nonatomic,copy) void (^checkBlock) (UHNiBPModel *model);
@end
