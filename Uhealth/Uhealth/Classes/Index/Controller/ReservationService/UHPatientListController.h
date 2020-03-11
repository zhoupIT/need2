//
//  UHPatientListController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHPatientListModel.h"
@interface UHPatientListController : UIViewController
@property (nonatomic,copy) void (^selectedPatientBlock) (UHPatientListModel *model);
@property (nonatomic,assign) NSInteger type;
@end
