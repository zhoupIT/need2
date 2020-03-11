//
//  UHHistoryStepsController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHistoryStepsController.h"
#import "UHHistoryStepsCell.h"
#import "iOS-Echarts.h"
#import "PYEchartsView.h"
#import "PYZoomEchartsView.h"
#import "UHStepModel.h"
#import "DateTools.h"
@interface UHHistoryStepsController ()<UICollectionViewDelegate,UICollectionViewDataSource,PYEchartsViewDelegate>
@property (nonatomic,strong) UIImageView *calendarIcon;
@property (nonatomic,strong) UILabel *calendarLabel;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) PYZoomEchartsView *kEchartView;
@property (nonatomic,strong) UIButton *leftArrow;
@property (nonatomic,strong) UIButton *rightArrow;

@property (nonatomic,strong) UILabel *stepNumsValueLabel;
@property (nonatomic,strong) UILabel *stepNumsLabel;

@property (nonatomic,strong) UILabel *calValueLabel;
@property (nonatomic,strong) UILabel *calLabel;

@property (nonatomic,strong) UIImageView *circleIcon;
@property (nonatomic,strong) UILabel *circleTipLabel;
@property (nonatomic,strong) UILabel *circleTipValueLabel;


@property (nonatomic,strong) UIButton *circleBtn;
@property (nonatomic,strong) UIButton *calBtn;

//步数数组
@property (nonatomic,strong) NSMutableArray *data;
//时间 步数数组
@property (nonatomic,strong) NSArray *stepModelData;

@property (nonatomic,strong) UHStepModel *model;
@end

@implementation UHHistoryStepsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self getNewSteps:@"" andEndDate:@""];
}

- (void)initAll {
     self.title = @"历史记录";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view sd_addSubviews:@[self.calendarIcon,self.calendarLabel,self.collectionView]];
    self.calendarIcon.sd_layout
    .leftSpaceToView(self.view, ZPWidth(16))
    .topSpaceToView(self.view, ZPHeight(10))
    .heightIs(ZPHeight(20))
    .widthIs(ZPWidth(22));
    
    self.calendarLabel.sd_layout
    .leftSpaceToView(self.calendarIcon, ZPWidth(8))
    .centerYEqualToView(self.calendarIcon)
    .rightSpaceToView(self.view, 0)
    .autoHeightRatio(0);
    
    [self.view addSubview:self.kEchartView];
    self.kEchartView.backgroundColor =  RGB(246,251,255);
    self.kEchartView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.calendarIcon, ZPHeight(10))
    .rightSpaceToView(self.view, 0)
    .heightIs(ZPHeight(260));
    self.kEchartView.userInteractionEnabled = YES;
    [self.kEchartView setOption:[self standardLineOption]];
    [self.kEchartView loadEcharts];
    WEAK_SELF(weakSelf);
    [self.kEchartView addHandlerForAction:PYEchartActionClick withBlock:^(NSDictionary *params) {
        NSLog(@"The params from Echarts:\n%@", params);
        [weakSelf handleSteps:[[params objectForKey:@"data"] integerValue]];
    }];
    
    [self.kEchartView sd_addSubviews:@[self.leftArrow,self.rightArrow]];
    self.leftArrow.sd_layout
    .topSpaceToView(self.kEchartView, ZPHeight(10))
    .leftSpaceToView(self.kEchartView, ZPWidth(16))
    .widthIs(22)
    .heightIs(22);
    
    self.rightArrow.sd_layout
    .topSpaceToView(self.kEchartView, ZPHeight(10))
    .rightSpaceToView(self.kEchartView, ZPWidth(16))
    .widthIs(22)
    .heightIs(22);
    
    [self.view sd_addSubviews:@[self.stepNumsValueLabel,self.stepNumsLabel,self.calValueLabel,self.calLabel,self.circleIcon,self.circleBtn,self.calBtn]];
    self.circleIcon.sd_layout
    .widthIs(ZPWidth(80))
    .heightIs(ZPWidth(80))
    .centerXEqualToView(self.view)
    .topSpaceToView(self.kEchartView, ZPHeight(27));
    
    [self.circleIcon sd_addSubviews:@[self.circleTipLabel,self.circleTipValueLabel]];
    self.circleTipLabel.sd_layout
    .topSpaceToView(self.circleIcon, ZPHeight(25))
    .leftSpaceToView(self.circleIcon, 0)
    .rightSpaceToView(self.circleIcon, 0)
    .heightIs(ZPHeight(15));
    
    self.circleTipValueLabel.sd_layout
    .topSpaceToView(self.circleTipLabel, ZPHeight(8))
    .leftSpaceToView(self.circleIcon, 0)
    .rightSpaceToView(self.circleIcon, 0)
    .heightIs(ZPHeight(15));
    
    
    self.stepNumsValueLabel.sd_layout
    .topSpaceToView(self.kEchartView, ZPHeight(52))
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.circleIcon, 5)
    .heightIs(ZPHeight(19));
    
    self.stepNumsLabel.sd_layout
    .topSpaceToView(self.stepNumsValueLabel, ZPHeight(10))
    .heightIs(ZPHeight(15))
    .centerXEqualToView(self.stepNumsValueLabel);
    [self.stepNumsLabel setSingleLineAutoResizeWithMaxWidth:20];
    
    self.calValueLabel.sd_layout
    .topSpaceToView(self.kEchartView, ZPHeight(52))
    .leftSpaceToView(self.circleIcon, 0)
    .rightSpaceToView(self.view, 5)
    .heightIs(ZPHeight(19));
    
    self.calLabel.sd_layout
    .topSpaceToView(self.calValueLabel, ZPHeight(10))
    .heightIs(ZPHeight(15))
    .centerXEqualToView(self.calValueLabel);
    [self.calLabel setSingleLineAutoResizeWithMaxWidth:20];
    
    self.circleBtn.sd_layout
    .topSpaceToView(self.circleIcon, ZPHeight(37))
    .heightIs(ZPHeight(54))
    .widthIs(ZPWidth(260))
    .centerXEqualToView(self.view);
    self.circleBtn.imageView.sd_layout
    .widthIs(ZPWidth(60))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.circleBtn)
    .leftSpaceToView(self.circleBtn, ZPWidth(24));
    self.circleBtn.titleLabel.sd_layout
    .leftSpaceToView(self.circleBtn.imageView, ZPWidth(50))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.circleBtn)
    .rightSpaceToView(self.circleBtn, 0);
    
    
    self.calBtn.sd_layout
    .topSpaceToView(self.circleBtn, ZPHeight(14))
    .heightIs(ZPHeight(54))
    .widthIs(ZPWidth(260))
    .centerXEqualToView(self.view);
    self.calBtn.imageView.sd_layout
    .widthIs(ZPWidth(60))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.calBtn)
    .leftSpaceToView(self.calBtn, ZPWidth(24));
    self.calBtn.titleLabel.sd_layout
    .leftSpaceToView(self.calBtn.imageView, ZPWidth(50))
    .heightIs(ZPHeight(40))
    .centerYEqualToView(self.calBtn)
    .rightSpaceToView(self.calBtn, 0);
   
}

- (void)handleSteps:(NSInteger)steps {
    UHStepModel *model = [[UHStepModel alloc] init];
    if(steps >0) {
        model.stepsCount = steps;
        model.progress = floorf(steps/100);
        model.liDis = [NSString stringWithFormat:@"%0.2f", steps*0.00075015];
        model.circle = [NSString stringWithFormat:@"%0.1f", ((CGFloat)steps*0.00075015)*1000/400];
        model.calorie = round(steps*0.03620225);
        model.cocoNums = round(steps*0.03620225)/141.9;
        ZPLog(@"%@",model);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.stepNumsValueLabel.text = [NSString stringWithFormat:@"%ld",model.stepsCount];
            self.calValueLabel.text = [NSString stringWithFormat:@"%ld",model.calorie];
            [self.circleBtn setTitle:[NSString stringWithFormat:@"≈绕操场%@圈",model.circle] forState:UIControlStateNormal];
            [self.calBtn setTitle:[NSString stringWithFormat:@"≈%ld杯可乐的热量",model.cocoNums] forState:UIControlStateNormal];
            self.circleTipValueLabel.text = [NSString stringWithFormat:@"%d%%",(int)model.progress];
        });
        
    }
    self.model = model;
    
}



- (PYOption *)standardLineOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
            tooltip.axisPointerEqual([PYAxisPointer initPYAxisPointerWithBlock:^(PYAxisPointer *axisPoint) {
                axisPoint.typeEqual(PYAxisPointerTypeLine);
                axisPoint.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }]);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50);
            grid.borderWidthEqual(@0);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"步数"]);
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@NO)
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(YES);
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(YES);
                axisTick.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                }]);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(NO);
            }])
            .addDataArr(@[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(YES);
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#d7e8f2"]);
                }]);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value}");
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                }]);
            }]);
            
        }])
        .addSeries([PYSeries initPYSeriesWithBlock:^(PYSeries *series) {
            series.nameEqual(@"步数")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
                    itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                        lineStyle.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
                        
                    }]);
                }]);
            }])
            .dataEqual(self.data);
        }]);
    }];
}

- (void)leftAction {
     ZPLog(@"左滑");
    if (self.stepModelData.count) {
        UHStepModel *model = self.stepModelData.firstObject;
        NSString *firstdayString = model.stepsDate;
        [self getNewSteps:firstdayString andEndDate:@""];
    } else {
        [MBProgressHUD showError:@"暂无数据"];
    }
}

- (void)rightAction {
    ZPLog(@"右滑");
    if (self.stepModelData.count) {
        UHStepModel *model = self.stepModelData.lastObject;
        NSString *lastdayString = model.stepsDate;
        NSDate *lastday = [NSDate dateWithString:lastdayString formatString:@"yyyy-MM-dd"];
        if (![lastday isLaterThanOrEqualTo:[NSDate date]]) {
            [self getNewSteps:@"" andEndDate:lastdayString];
        } else {
            //最后一天 大于等于今天 就不能滑动
            [MBProgressHUD showError:@"暂无数据"];
        }
        
    } else {
        [MBProgressHUD showError:@"暂无数据"];
    }
}


- (void)getNewSteps:(NSString *)startDate andEndDate:(NSString *)endDate {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"customer/steps" parameters:@{@"startDate":startDate,@"endDate":endDate} progress:^(NSProgress *progress) {
        ZPLog(@"%@",progress);
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSArray *array =  [UHStepModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            if (array.count) {
                [weakSelf.data removeAllObjects];
                for (UHStepModel *model in array) {
                    if (model.stepsCount != nil) {
                        [weakSelf.data addObject:[NSNumber numberWithInteger:model.stepsCount]];
                    } else {
                        [weakSelf.data addObject:@"-"];
                    }
                }
                weakSelf.stepModelData = array;
                UHStepModel *fitstM = weakSelf.stepModelData.firstObject;
                UHStepModel *lastM = weakSelf.stepModelData.lastObject;
                NSString *firstS = [fitstM.stepsDate substringFromIndex:5];
                NSString *lastS = [lastM.stepsDate substringFromIndex:5];
                
                weakSelf.calendarLabel.text = [NSString stringWithFormat:@"%@-%@",[firstS stringByReplacingOccurrencesOfString:@"-" withString:@"."],[lastS stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
                ZPLog(@"数据获取到了:%@",weakSelf.data);
                [weakSelf.kEchartView setOption:[self standardLineOption]];
                [weakSelf.kEchartView loadEcharts];
            }
        } else {
            
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHHistoryStepsController class]];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
       
       
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        
    }
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UHHistoryStepsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UHHistoryStepsCell class]) forIndexPath:indexPath];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - -echarts的代理方法
- (BOOL)echartsView:(PYEchartsView *)echartsView didReceivedLinkURL:(NSURL *)url {
    ZPLog(@"echarts的代理方法%@",url);
    return YES;
}

/**
 *  When the options are loaded complete, this method will be called for user
 *
 *  @param echartsView The echatsView provide this action
 */
- (void)echartsViewDidFinishLoad:(PYEchartsView *)echartsView {
    ZPLog(@"echarts的代理方法 完成了");
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸(行距,列距)
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置cell的宽度
        //ZPWidth(165)
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, ZPHeight(300));
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UHHistoryStepsCell class] forCellWithReuseIdentifier:NSStringFromClass([UHHistoryStepsCell class])];
    }
    return _collectionView;
}

- (UILabel *)stepNumsLabel {
    if (!_stepNumsLabel) {
        _stepNumsLabel = [UILabel new];
        _stepNumsLabel.textColor = ZPMyOrderDetailValueFontColor;
        _stepNumsLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
        _stepNumsLabel.text = @"步";
    }
    return _stepNumsLabel;
}

- (UILabel *)stepNumsValueLabel {
    if (!_stepNumsValueLabel) {
        _stepNumsValueLabel = [UILabel new];
        _stepNumsValueLabel.textColor = ZPMyOrderDetailValueFontColor;
        _stepNumsValueLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)];
        _stepNumsValueLabel.text = @"0";
        _stepNumsValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stepNumsValueLabel;
}

- (UILabel *)calLabel {
    if (!_calLabel) {
        _calLabel = [UILabel new];
        _calLabel.textColor = RGB(255,180,0);
        _calLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
        _calLabel.text = @"卡";
    }
    return _calLabel;
}

- (UILabel *)calValueLabel {
    if (!_calValueLabel) {
        _calValueLabel = [UILabel new];
        _calValueLabel.textColor = RGB(255,180,0);
        _calValueLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(25)];
        _calValueLabel.text = @"0";
        _calValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _calValueLabel;
}

- (UIImageView *)circleIcon {
    if (!_circleIcon) {
        _circleIcon = [UIImageView new];
        _circleIcon.image = [UIImage imageNamed:@"step_goal_icon"];
    }
    return _circleIcon;
}

- (UIButton *)circleBtn {
    if (!_circleBtn) {
        _circleBtn = [UIButton new];
        _circleBtn.layer.borderColor = RGB(77, 199, 4).CGColor;
        _circleBtn.layer.borderWidth = 1;
        _circleBtn.layer.cornerRadius = 4;
        _circleBtn.layer.masksToBounds = YES;
        [_circleBtn setImage:[UIImage imageNamed:@"step_footground_icon"] forState:UIControlStateNormal];
        [_circleBtn setTitle:@"≈绕操场0圈" forState:UIControlStateNormal];
        [_circleBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _circleBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    }
    return _circleBtn;
}

- (UIButton *)calBtn {
    if (!_calBtn) {
        _calBtn = [UIButton new];
        _calBtn.layer.borderColor = RGB(255,180,0).CGColor;
        _calBtn.layer.borderWidth = 1;
        _calBtn.layer.cornerRadius = 4;
        _calBtn.layer.masksToBounds = YES;
        [_calBtn setImage:[UIImage imageNamed:@"step_heat_icon"] forState:UIControlStateNormal];
        [_calBtn setTitle:@"≈0杯可乐的热量" forState:UIControlStateNormal];
        [_calBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _calBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    }
    return _calBtn;
}

- (UIImageView *)calendarIcon {
    if (!_calendarIcon) {
        _calendarIcon = [UIImageView new];
        _calendarIcon.image = [UIImage imageNamed:@"stepHistory_cal_icon"];
    }
    return _calendarIcon;
}

- (UILabel *)calendarLabel {
    if (!_calendarLabel) {
        _calendarLabel = [UILabel new];
        _calendarLabel.textColor = ZPMyOrderDetailValueFontColor;
        _calendarLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(16)];
    }
    return _calendarLabel;
}

- (PYZoomEchartsView *)kEchartView {
    if (!_kEchartView) {
        _kEchartView = [PYZoomEchartsView new];
        _kEchartView.eDelegate = self;
    }
    return _kEchartView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray arrayWithArray:@[@"-",@"-",@"-",@"-",@"-",@"-",@"-"]];
    }
    return _data;
}

- (UIButton *)leftArrow {
    if (!_leftArrow) {
        _leftArrow = [UIButton new];
        [_leftArrow setImage:[UIImage imageNamed:@"step_leftArrow_icon"] forState:UIControlStateNormal];
        [_leftArrow addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftArrow;
}

- (UIButton *)rightArrow {
    if (!_rightArrow) {
        _rightArrow = [UIButton new];
        [_rightArrow setImage:[UIImage imageNamed:@"step_rightArrow_icon"] forState:UIControlStateNormal];
        [_rightArrow addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightArrow;
}

- (NSArray *)stepModelData {
    if (!_stepModelData) {
        _stepModelData = [NSArray array];
    }
    return _stepModelData;
}

- (UILabel *)circleTipLabel {
    if (!_circleTipLabel) {
        _circleTipLabel = [UILabel new];
        _circleTipLabel.textColor = ZPMyOrderDetailValueFontColor;
        _circleTipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
        _circleTipLabel.textAlignment= NSTextAlignmentCenter;
        _circleTipLabel.text = @"达成目标";
    }
    return _circleTipLabel;
}

- (UILabel *)circleTipValueLabel {
    if (!_circleTipValueLabel) {
        _circleTipValueLabel = [UILabel new];
        _circleTipValueLabel.textColor = ZPMyOrderDetailValueFontColor;
        _circleTipValueLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(16)];
        _circleTipValueLabel.textAlignment= NSTextAlignmentCenter;
        _circleTipValueLabel.text = @"0%";
    }
    return _circleTipValueLabel;
}
@end
