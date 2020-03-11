//
//  UHUserHeaderView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHUserModel;
@interface UHUserHeaderView : UIView

@property (nonatomic, copy) void(^aboutBlock)();
@property (nonatomic,copy) void (^perosonalInfoBlock)();
@property (nonatomic, copy) void(^collectionGoodBlock)();
@property (nonatomic, copy) void(^collectionStoreBlock)();
@property (nonatomic,copy) void (^loginBlock) (void);


+ (instancetype)headerView;
@property (nonatomic,strong) UHUserModel *model;
@end
