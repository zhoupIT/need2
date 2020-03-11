//
//  UHHomeFunctionCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHHomeFunctionCell : UITableViewCell
@property (nonatomic,copy) void (^didClickBlock) (NSInteger tag);
@end
