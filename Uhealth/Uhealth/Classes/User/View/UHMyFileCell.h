//
//  UHMyFileCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyFileModel;
@interface UHMyFileCell : UITableViewCell
@property (nonatomic,copy) void (^clickBlock) (void);
@property (nonatomic,strong) UHMyFileModel *model;
@end
