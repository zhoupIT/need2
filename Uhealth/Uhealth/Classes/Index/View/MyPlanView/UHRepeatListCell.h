//
//  UHRepeatListCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHRepeatListModel;
@interface UHRepeatListCell : UITableViewCell
@property (nonatomic,copy) void (^selBlock) (void);
@property (nonatomic,strong) UHRepeatListModel *model;
@end
