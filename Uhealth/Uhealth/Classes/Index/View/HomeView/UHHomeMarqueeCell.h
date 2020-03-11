//
//  UHHomeMarqueeCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHHomeMarqueeCell : UITableViewCell
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy) void (^didClickBlock) (NSInteger index);
@end
