//
//  tempClass.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger,UHOrderType) {
    UHOrderType1,
    UHOrderType2,
    UHOrderType3,
    UHOrderType4
};
@interface tempClass : NSObject
@property (nonatomic,assign) UHOrderType ordertype;
@end
