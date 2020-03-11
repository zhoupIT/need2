//
//  UHPayCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHPayModel;
@interface UHPayCell : UITableViewCell
@property (nonatomic,copy) void (^selBlock) (UIButton *btn);
@property (nonatomic,strong) UHPayModel *model;
@end
