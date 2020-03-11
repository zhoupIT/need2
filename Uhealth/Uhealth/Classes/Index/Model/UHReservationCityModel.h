//
//  UHReservationCityModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHReservationCityModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,copy) NSString *cityServices;
@property (nonatomic,assign) BOOL isSel;
@end
