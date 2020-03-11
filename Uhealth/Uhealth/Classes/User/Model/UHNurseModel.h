//
//  UHNurseListModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHNurseModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cabinId;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *nurseImg;
@property (nonatomic,copy) NSString *nurseName;
@property (nonatomic,copy) NSString *nurseIntroduction;
@property (nonatomic,copy) NSString *nursePosition;
@property (nonatomic,copy) NSString *nursePhone;
@property (nonatomic,copy) NSString *priority;
@property (nonatomic,copy) NSString *adress;
@end
