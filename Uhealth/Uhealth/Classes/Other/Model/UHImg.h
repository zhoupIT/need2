//
//  UHImg.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UHImg : NSObject
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
