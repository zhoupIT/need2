//
//  UHPatientListCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHPatientListModel;
@interface UHPatientListCell : UITableViewCell
@property (nonatomic,strong) UHPatientListModel *model;
@property (nonatomic,copy) void (^selctActionBlock) (UIButton *btn);

@property (nonatomic,copy) void (^editBlock) (UIButton *btn);
@end
