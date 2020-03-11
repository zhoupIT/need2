//
//  UHReservationView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPTextView.h"
@class UHPrice,UHPatientListModel;
@interface UHReservationView : UIView
@property (nonatomic,strong) ZPTextView *descTextView;
@property (nonatomic,copy) void (^commitAppointmentBlock) (void);
@property (nonatomic,copy) void (^addPerBlock) (void);
@property (nonatomic,copy) void (^deleteBlock) (void);
@property (nonatomic,copy) void (^callBlock) (void);

@property (nonatomic,strong) UHPrice *model;
@property (nonatomic,strong) UHImg *processImage;

- (void)updateUIWithModel:(UHPatientListModel *)model;

@end
