//
//  ZPToast.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPNotfication : NSObject
+ (void)showNotificationWithMessage:(NSString *)message completionBlock:(void (^)(void))completion;;
@end
