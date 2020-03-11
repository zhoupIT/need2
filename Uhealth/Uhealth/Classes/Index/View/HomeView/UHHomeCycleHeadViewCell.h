//
//  UHHomeCycleHeadViewCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHHomeCycleHeadViewCell : UITableViewCell
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy) void (^bannerImgClickBlock) (NSInteger index);
@property (nonatomic,copy) void (^psyClickBlock) (void);
@property (nonatomic,copy) void (^phyClickBlock) (void);
@end
