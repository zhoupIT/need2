//
//  UHMyFileDetailModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHMyFileInfoModel.h"
#import "UHModelValueModel.h"
@interface UHMyFileDetailModel : NSObject
@property (nonatomic,copy) NSString *modelName;
@property (nonatomic,strong) NSArray *modelValue;
@property (nonatomic,strong) UHMyFileInfoModel *filedForIos;
@property (nonatomic,strong) UHCommonEnumType *type;

@end
