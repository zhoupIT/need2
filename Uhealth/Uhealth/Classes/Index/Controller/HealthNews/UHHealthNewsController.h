//
//  UHHealthNewsController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHHealthNewsModel;
@interface UHHealthNewsController : UITableViewController
@property (nonatomic,copy) void (^didClickBlock) (NSString *mainBody,UHHealthNewsModel *healthNewsModel);
@property (nonatomic,assign) NSInteger pageIndex;
@end
