//
//  UHNurseSubCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHNurseModel;
@interface UHNurseSubCell : UICollectionViewCell
@property (nonatomic,strong) UHNurseModel *model;
@property (nonatomic,copy) void (^contactNurseBlock) (UHNurseModel *model);
@end
