//
//  UHHomeCenterCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHHomeCenterCell : UITableViewCell
@property (nonatomic,copy) void (^didClickBlock) (NSInteger tag);
@end