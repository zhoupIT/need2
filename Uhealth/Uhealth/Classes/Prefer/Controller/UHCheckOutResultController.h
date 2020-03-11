//
//  UHCheckOutResultController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger,ZPEnterResultType) {
    ZPEnterResultCart,
    ZPEnterResultOrderDetail,
    ZPEnterResultMyOrder,
    ZPEnterResultGreenPath
};
@interface UHCheckOutResultController : UIViewController
@property (nonatomic,assign) ZPEnterResultType enterResultType;
@end
