//
//  UHPsychologicalAssessmentInfoTFCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHPsychologicalAssessmentInfoTFCell : UITableViewCell
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) void (^updateNameBlock) (NSString *newName);
@end
