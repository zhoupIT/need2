//
//  UHAddPatientController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHPatientListModel;
@interface UHAddPatientController : UIViewController
@property (nonatomic,copy) void (^addSuceesBlock) (void);
@property (nonatomic,copy) void (^updateSuceesBlock) (void);
@property (nonatomic,strong) UHPatientListModel *model;
@end
