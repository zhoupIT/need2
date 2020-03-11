//
//  UHServiceDetailView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyServiceModel;
@interface UHServiceDetailView : UIView
+ (instancetype)addServiceDetailView;
@property (nonatomic,strong) UHMyServiceModel *model;
@end
