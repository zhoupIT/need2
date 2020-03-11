//
//  UHMyFileInfoModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHMyFileInfoModel : NSObject
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *detectDate;
@property (nonatomic,strong) UHCommonEnumType *gender;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *subordindateUnit;
@end
