//
//  UHUserModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHUserGender.h"
@interface UHUserModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *portrait;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,strong) UHUserGender *gender;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *areaFull;
@property (nonatomic,copy) NSString *companyAddress;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *welcomeMessage;
//个人手机号码
@property (nonatomic,copy) NSString *phone;
@end
