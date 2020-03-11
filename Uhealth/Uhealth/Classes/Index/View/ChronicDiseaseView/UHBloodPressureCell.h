//
//  UHBloodPressureCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,ZPDiseaseType) {
    ZPDiseaseTypeBlood,
    ZPDiseaseTypeUa,
    ZPDiseaseTypeSpo,
    ZPDiseaseTypeGlu,
    ZPDiseaseTypeBody,
    ZPDiseaseTypeWeight,
    ZPDiseaseTypeBf
};
@class UHBloodPressureModel,UHNiBPModel;
@interface UHBloodPressureCell : UITableViewCell

@property (nonatomic,strong) UHBloodPressureModel *model;

@property (nonatomic,strong) UHNiBPModel *bibpModel;

@property (nonatomic,strong) UHNiBPModel *spoModel;

@property (nonatomic,strong) UHNiBPModel *gluModel;

@property (nonatomic,strong) UHNiBPModel *bodyIndexModel;

@property (nonatomic,strong) UHNiBPModel *weightModel;

//血脂
@property (nonatomic,strong) UHNiBPModel *bfModel;
//是否是企业用户
@property (nonatomic,assign) BOOL isCompany;

@property (nonatomic,copy) void (^checkBlock) (UHNiBPModel *model);

@property (nonatomic,assign) ZPDiseaseType diseaseType;
@end
