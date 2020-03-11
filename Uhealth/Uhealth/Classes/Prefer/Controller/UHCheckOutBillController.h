//
//  UHCheckOutBillController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,ZPEnterType) {
    ZPEnterCart,
    ZPEnterOrderDetail
};
@interface UHCheckOutBillController : UIViewController
@property (nonatomic,strong) NSArray *orderArray;
@property (nonatomic,assign) ZPEnterType entertype;
@property (nonatomic,copy) void (^emptyCartBlock) (void);

@end
