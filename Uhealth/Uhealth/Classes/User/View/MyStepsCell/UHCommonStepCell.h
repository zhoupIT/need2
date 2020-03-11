//
//  UHCommonStepCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UHStepModel;
@interface UHCommonStepCell : UITableViewCell
@property (nonatomic,assign) NSInteger indexPath;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *iconName;

@property (nonatomic,assign) double steps;
@property (nonatomic,strong) UHStepModel *model;
@end

NS_ASSUME_NONNULL_END
