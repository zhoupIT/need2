//
//  UHWeightController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHWeightController.h"
#import "iOS-Echarts.h"
#import "PYEchartsView.h"
#import "PYZoomEchartsView.h"
#import "UIView+WZB.h"
#import "UHBloodPressureModel.h"

#import "UHBloodPressureCell.h"

#import "UHWeightEnteringController.h"

#import "UHNiBPModel.h"
@interface UHWeightController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UISegmentedControl *headerSegment;

@property (nonatomic,strong) UIButton *enteringButton;

@property (nonatomic, strong) PYZoomEchartsView *kEchartView;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *bloodLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *fromLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *checkLabel;


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;

//体重数组
@property (nonatomic,strong) NSMutableArray *weightData;
//时间数组
@property (nonatomic,strong) NSMutableArray *dateArr;
@property (nonatomic,copy) NSString *btnType;
@end

@implementation UHWeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self setupRefresh];
    self.btnType  = @"TWENTY";
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_header endRefreshing];
        //血氧查询
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"weight" parameters:@{@"btnType":self.btnType} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHNiBPModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    weakSelf.data = [NSMutableArray arrayWithArray:arrays];
                    [tableView reloadData];
                    tableView.sd_layout.heightIs(40*weakSelf.data.count);
                    [weakSelf.scrollView setupAutoContentSizeWithBottomView:tableView bottomMargin:10];
                    [tableView updateLayout];
                    [weakSelf.scrollView updateLayout];
                    [weakSelf.weightData removeAllObjects];
                    [weakSelf.dateArr removeAllObjects];
                    for (UHNiBPModel *model in weakSelf.data) {
                        [weakSelf.weightData addObject:model.weight];
                        
//                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                        [formatter setDateFormat:@"yyyy-MM-dd HH-mm"];
//                        
//                        NSDate *resDate = [formatter dateFromString:model.detectDate];
//
//                        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
//                        dateformatter.dateFormat = @"MM/dd";
//                        NSString *str = [dateformatter stringFromDate:resDate];
                        [weakSelf.dateArr addObject:model.detectDate];
                    }
                    [weakSelf.kEchartView setOption:[weakSelf standardLineOption]];
                    [weakSelf.kEchartView loadEcharts];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHWeightController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
}

- (void)initAll {
    self.title = @"体重监测";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSegmentedControl];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(46, 0, 0, 0));
    
    self.kEchartView = [PYZoomEchartsView new];
    [self.scrollView addSubview:self.kEchartView];
    self.kEchartView.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.scrollView, 10)
    .rightSpaceToView(self.scrollView, 0)
    .heightIs(302);
    [self.kEchartView setOption:[self standardLineOption]];
    [self.kEchartView loadEcharts];
    
    [self.kEchartView addSubview:self.enteringButton];
    self.enteringButton.sd_layout
    .rightSpaceToView(self.kEchartView, 10)
    .heightIs(24)
    .widthIs(24)
    .topSpaceToView(self.kEchartView, 0);
    
    
    
    
    [self.scrollView addSubview:self.headView];
    self.headView.sd_layout
    .topSpaceToView(self.kEchartView, 0)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(40);
    
    [self.headView sd_addSubviews:@[self.bloodLabel,self.stateLabel,self.fromLabel,self.timeLabel,self.checkLabel]];
    self.bloodLabel.sd_layout
    .leftEqualToView(self.headView)
    .widthIs(self.isCompany?50:80)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    self.stateLabel.sd_layout
    .leftSpaceToView(self.bloodLabel, 0)
    .widthIs(100)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    self.fromLabel.sd_layout
    .leftSpaceToView(self.stateLabel, 0)
    .widthIs(60)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    if (self.isCompany) {
        self.checkLabel.sd_layout
        .widthIs(40)
        .rightSpaceToView(self.headView, 0)
        .topEqualToView(self.headView)
        .bottomEqualToView(self.headView);
        
        self.timeLabel.sd_layout
        .leftSpaceToView(self.fromLabel, 0)
        .rightSpaceToView(self.checkLabel, 0)
        .topEqualToView(self.headView)
        .bottomEqualToView(self.headView);
    } else {
        self.timeLabel.sd_layout
        .leftSpaceToView(self.fromLabel, 0)
        .rightEqualToView(self.headView)
        .topEqualToView(self.headView)
        .bottomEqualToView(self.headView);
    }
    
    
    [self.scrollView addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.headView, 0)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView);
}

//初始化Segmented控件
- (void)initSegmentedControl
{
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"最近20次",@"最近7天",@"最近30天",nil];
    self.headerSegment = [[UISegmentedControl alloc]initWithItems:segmentedData];
    //这个是设置按下按钮时的颜色
    self.headerSegment.tintColor = RGB(99,187,255);
    //默认选中的按钮索引
    self.headerSegment.selectedSegmentIndex = 0;
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,RGB(99, 187, 255), NSForegroundColorAttributeName, nil];
    [self.headerSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.headerSegment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    //设置分段控件点击相应事件
    [_headerSegment addTarget:self action:@selector(segmentSelect:)forControlEvents:UIControlEventValueChanged];
    //添加到视图
    [self.view addSubview:self.headerSegment];
    self.headerSegment.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(35)
    .topSpaceToView(self.view, 11);
}

/**
 *  选择时间节点类型
 */
- (void)segmentSelect:(UISegmentedControl *)control {
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            self.btnType = @"TWENTY";
            [self.tableView.mj_header beginRefreshing];
        }
            break;
        case 1:
        {
            self.btnType = @"WEEK";
            [self.tableView.mj_header beginRefreshing];
        }
            break;
        case 2:
        {
            self.btnType = @"MONTH";
            [self.tableView.mj_header beginRefreshing];
        }
            break;
            
        default:
            break;
    }
}

- (PYOption *)standardLineOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
            tooltip.axisPointerEqual([PYAxisPointer initPYAxisPointerWithBlock:^(PYAxisPointer *axisPoint) {
                axisPoint.typeEqual(PYAxisPointerTypeLine);
                axisPoint.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                    lineStyle.widthEqual(@1);
                    lineStyle.typeEqual(PYLineStyleTypeSolid);
                }]);
            }]);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50);
            grid.borderWidthEqual(@0);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"体重"]);
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@NO)
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#DC143C"]);
                }]);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(YES);
                axisTick.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#f2f2f2"]);
                }]);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"(function (params) {params = params.replace(/-/g,\"/\");var date = new Date(params);return (date.getMonth()+1) + '-' + date.getDate();})");
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#4A4A4A"]);
                }]);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(NO);
            }])
            .addDataArr([[self.dateArr reverseObjectEnumerator] allObjects]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(YES);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#f2f2f2"]);
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
            series.nameEqual(@"体重")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.colorEqual([PYColor colorWithHexString:@"#FFCC30"]);
                    itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                        lineStyle.colorEqual([PYColor colorWithHexString:@"#FFCC30"]);
                        
                    }]);
                }]);
            }])
            .dataEqual([[self.weightData reverseObjectEnumerator] allObjects])
            .markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.addDataArr(@[@{@"type" : @"max", @"name": @"最近7天最大值"},@{@"type" : @"min", @"name": @"最近7天最小值"}]);
            }]);
        }]);
    }];
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHBloodPressureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHBloodPressureCell class])];
    cell.weightModel = self.data[indexPath.row];
    cell.checkBlock = ^(UHNiBPModel *model) {
        if (!ZPIsExist_String(model.testRecordId)) {
            [MBProgressHUD showError:@"无报告"];
            return;
        }
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"idata/message" parameters:@{@"testRecordID":model.testRecordId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
              [EBBannerView showWithContent:[[response objectForKey:@"data"] objectForKey:@"message"]];
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        } className:[UHWeightController class]];
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)enterBloodValue {
    __weak typeof(self) weakSelf = self;
    UHWeightEnteringController *enterControl = [[UHWeightEnteringController alloc] init];
    enterControl.updateListBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:enterControl animated:YES];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = RGB(99, 187, 255);
    }
    return _headView;
}

- (UILabel *)bloodLabel {
    if (!_bloodLabel) {
        _bloodLabel = [UILabel new];
        _bloodLabel.textAlignment = NSTextAlignmentCenter;
        _bloodLabel.textColor = [UIColor whiteColor];
        _bloodLabel.font = [UIFont systemFontOfSize:13];
        _bloodLabel.text = @"体重(kg)";
        _bloodLabel.numberOfLines = 2;
    }
    return _bloodLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.text = @"状态";
    }
    return _stateLabel;
}

- (UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [UILabel new];
        _fromLabel.textAlignment = NSTextAlignmentCenter;
        _fromLabel.textColor = [UIColor whiteColor];
        _fromLabel.font = [UIFont systemFontOfSize:13];
        _fromLabel.text = @"来源";
    }
    return _fromLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.text = @"时间";
    }
    return _timeLabel;
}

- (UILabel *)checkLabel {
    if (!_checkLabel) {
        _checkLabel = [UILabel new];
        _checkLabel.font = [UIFont systemFontOfSize:13];
        _checkLabel.text = @"报告";
        _checkLabel.textColor = [UIColor whiteColor];
        _checkLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _checkLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHBloodPressureCell class] forCellReuseIdentifier:NSStringFromClass([UHBloodPressureCell class])];
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (UIButton *)enteringButton {
    if (!_enteringButton) {
        _enteringButton = [UIButton new];
        [_enteringButton setImage:[UIImage imageNamed:@"index_edit"] forState:UIControlStateNormal];
        [_enteringButton addTarget:self action:@selector(enterBloodValue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enteringButton;
}

- (NSMutableArray *)weightData {
    if (!_weightData) {
        _weightData = [NSMutableArray array];
    }
    return _weightData;
}

- (NSMutableArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
@end
