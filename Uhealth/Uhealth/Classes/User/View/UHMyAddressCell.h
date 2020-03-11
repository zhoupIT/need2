//
//  UHMyAddressCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UHAddressModel;
@interface UHMyAddressCell : UITableViewCell
@property (nonatomic,copy) void (^selectAction) (void);
@property (nonatomic,copy) void (^editAction) (void);
@property (nonatomic,copy) void (^deleteAction) (void);

@property (nonatomic,strong) UHAddressModel *model;
@end
