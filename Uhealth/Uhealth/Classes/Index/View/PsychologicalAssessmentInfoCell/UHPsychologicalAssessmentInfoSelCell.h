//
//  UHPsychologicalAssessmentInfoSelCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHPsyModel.h"
#import "UHPsyAssessmentModel.h"
@interface UHPsychologicalAssessmentInfoSelCell : UITableViewCell
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) UHPsyModel *model;
@property (nonatomic,strong) UHPsyAssessmentModel *retireModel;
@property (nonatomic,strong) UHPsyAssessmentModel *psyModel;
@property (nonatomic,copy) void (^selBlock) (UIButton *btn);
@property (nonatomic,copy) void (^selGenderBlock) (UIButton *btn);
@end
