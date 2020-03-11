//
//  UHMyFileCommonCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyFileDetailModel;
@interface UHMyFileCommonCell : UITableViewCell
@property (nonatomic,strong) UHMyFileDetailModel *model;
@property (nonatomic,assign) BOOL isLastData;
@end
