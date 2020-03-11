//
//  ZPToast.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPNotfication.h"
#import "CRToast.h"
@implementation ZPNotfication
+ (void)showNotificationWithMessage:(NSString *)message completionBlock:(void (^)(void))completion;{
    NSDictionary *options = @{
                              kCRToastTextKey : message,
                              kCRToastAnimationInDirectionKey : @(0),
                              kCRToastAnimationInTypeKey : @(0),
                              kCRToastAnimationOutDirectionKey : @(0),
                              kCRToastAnimationOutTypeKey : @(0),
                              kCRToastImageAlignmentKey : @(0),
                              kCRToastNotificationPreferredPaddingKey : @(0),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar) ,
                              kCRToastTextAlignmentKey : @(0),
                              kCRToastTimeIntervalKey : @(1),
                              kCRToastUnderStatusBarKey : @(NO),
                              kCRToastBackgroundColorKey : KCommonBlue
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:completion];
}
@end
