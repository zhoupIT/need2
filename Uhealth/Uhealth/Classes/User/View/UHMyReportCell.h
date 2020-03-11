//
//  UHMyReportCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyReportModel;
@interface UHMyReportCell : UITableViewCell
@property (nonatomic,strong) UHMyReportModel *model;
@property (nonatomic,assign) NSInteger pageIndex;
@end
