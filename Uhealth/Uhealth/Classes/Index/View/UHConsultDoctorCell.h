//
//  UHConsultDoctorCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/17.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHConsultDoctorModel;
@interface UHConsultDoctorCell : UITableViewCell
@property (nonatomic,strong) UHConsultDoctorModel *model;
@property (nonatomic,copy) void (^consultBlock) (void);
@property (nonatomic,copy) void (^modalInfoBlock) (UHConsultDoctorModel *model);
@property (nonatomic,assign) NSInteger index;
@end
