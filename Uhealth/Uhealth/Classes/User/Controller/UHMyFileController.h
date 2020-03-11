//
//  UHMyFileController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHMyFileController : UITableViewController
@property (nonatomic,copy) void (^detailClickBlock) (NSString *ID);
@property (nonatomic,assign) NSInteger pageIndex;
@end
