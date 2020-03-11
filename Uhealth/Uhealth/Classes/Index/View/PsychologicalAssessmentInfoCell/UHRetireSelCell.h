//
//  UHRetireSelCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHPsyModel.h"
#import "UHPsyAssessmentModel.h"
@interface UHRetireSelCell : UITableViewCell
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) void (^selBlock) (UIButton *btn);
@property (nonatomic,strong) UHPsyModel *model;
@property (nonatomic,strong) UHPsyAssessmentModel *psyModel;
@end
