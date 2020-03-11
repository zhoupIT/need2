//
//  NSObject+UHLocalNotification.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UHLocalNotification)
/**
 *   注册通知 为NSObject 扩展本地通知的分类
 *
 *   @param   time          距离当前时间为多少秒发送通知
 *   @param   content       推送通知的内容
 *   @param   key           注册通知的key值
 */
+ (void)registerLocalNotification:(NSDate *)time content:(NSString *)content key:(NSString *)key interval:(NSCalendarUnit)interval;


/**
 *   取消通知
 *
 *  @param   key   根据key值取消对应通知
 */
+ (void)cancelLocalNotificationWithKey:(NSString *)key;
@end
