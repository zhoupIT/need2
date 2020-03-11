//
//  UHLivingBroadcastTopCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHLectureModel;
@interface UHLivingBroadcastTopCell : UITableViewCell
@property (nonatomic,strong) UHLectureModel *model;
@property (nonatomic,copy) void (^moreHistoryLecturesBlock) (void);
@property (nonatomic,copy) void (^enterLectureBlock) (void);
@end
