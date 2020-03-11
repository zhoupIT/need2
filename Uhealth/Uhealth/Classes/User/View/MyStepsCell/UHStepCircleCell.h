//
//  UHStepCircleCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UHStepModel;
@interface UHStepCircleCell : UITableViewCell
@property (nonatomic,strong) UHStepModel *model;
@property (nonatomic,copy) void (^updateStepsBlock) (void);
@end

NS_ASSUME_NONNULL_END
