//
//  UHNotiModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHNotiModel : NSObject
@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *extraParam;
@property (nonatomic,strong) UHCommonEnumType *messageType;
@property (nonatomic,strong) UHCommonEnumType *messageStatus;
@property (nonatomic,copy) NSString *sendTime;
@end
