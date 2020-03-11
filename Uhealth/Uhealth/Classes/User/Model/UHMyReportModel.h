//
//  UHMyReportModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHMyReportModel : NSObject
@property (nonatomic,copy) NSString *memberID;
@property (nonatomic,copy) NSString *testRecordID;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,strong) UHCommonEnumType *datagramType;
@property (nonatomic,strong) UHCommonEnumType *evaluatingType;
@end
