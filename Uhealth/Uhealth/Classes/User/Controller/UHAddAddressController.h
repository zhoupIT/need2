//
//  UHAddAddressController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHAddressModel;
typedef NS_ENUM (NSInteger,ZPEnterType) {
    ZPEnterTypeAdd,
    ZPEnterTypeEdit
};
@interface UHAddAddressController : UIViewController
@property (nonatomic,copy) void (^addAddressBlock) (void);
@property (nonatomic,assign) ZPEnterType enterType;
@property (nonatomic,strong) UHAddressModel *model;
@end
