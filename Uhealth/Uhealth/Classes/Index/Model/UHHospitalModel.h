//
//  UHHospitalModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UHHospitalModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cityServiceId;
@property (nonatomic,copy) NSString *hospitalName;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,assign) BOOL isSel;//是否被选中
@end

NS_ASSUME_NONNULL_END
