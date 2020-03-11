//
//  UHMyStepsController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyStepsController.h"
#import "HealthKitManage.h"
#import "UHCommonStepCell.h"
#import "UHStepCircleCell.h"
#import "UHStepModel.h"
#import "UHHistoryStepsController.h"
#import "DateTools.h"
#import "UHLoginController.h"
#import "UHNavigationController.h"
@interface UHMyStepsController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray<NSDictionary *> *Items;
@property (nonatomic,assign) double steps;//步数
@property (nonatomic, assign) CGFloat scrollOffsetY;
@property (nonatomic,strong) UHStepModel *model;
@end

@implementation UHMyStepsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self initData];
}

- (void)initAll {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的步数";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"step_mysteps_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(historySteps)];
    
//     self.steps = 0;
//
//     [self handleSteps:self.steps];
//     [self.tableView reloadData];

}

- (void)initData {
     HealthKitManage *manage = [HealthKitManage shareInstance];
     [manage authorizeHealthKit:^(BOOL success, NSError *error) {
         if (success) {
             WEAK_SELF(weakSelf);
             NSInteger year = [[NSDate date] year];
             NSInteger day = [[NSDate date] day];
             NSInteger month = [[NSDate date] month];
           
             NSString *dateString = [[NSDate dateWithYear:year month:month day:day] formattedDateWithFormat:@"yyyy-MM-dd"];
             
             [manage getStepCountWithDateString:dateString complete:^(double value, NSError * _Nonnull error) {
                 if (!error) {
                     ZPLog(@"时间:%@-->步数:%.0f",dateString, value);
                    
                     dispatch_async(dispatch_get_main_queue(), ^{
                        
                             [weakSelf handleSteps:value];
                             [weakSelf.tableView reloadData];
                     });
                 }
             }];
         } else {
             ZPLog(@"HealthKitManage fail");
         }
     }];
}

- (void)update {
    if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        //未登录的状态
        UHLoginController *loginControl = [[UHLoginController alloc] init];
        UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    } else {
    HealthKitManage *manage = [HealthKitManage shareInstance];
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"同步中,请稍等"];
            });
            
            NSInteger year = [[NSDate date] year];
            NSInteger day = [[NSDate date] day];
            NSInteger month = [[NSDate date] month];
            NSDate *currentDate = [NSDate date];
            
            int days = 30;    // n天后的天数
            NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
            dispatch_group_t group = dispatch_group_create();
            
            
            if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
                 //更新过数据
                for (NSInteger i = 0; i<=days; i++) {
                    NSDate *appointDate;    // 指定日期声明
                    appointDate = [currentDate initWithTimeIntervalSinceNow: -(oneDay * i)];
                    ZPLog(@"多少天前%@",[appointDate formattedDateWithFormat:@"yyyy-MM-dd"]);
                    //               NSString *dateString = [[NSDate dateWithYear:year month:month day:i] formattedDateWithFormat:@"yyyy-MM-dd"];
                    NSString *dateString = [appointDate formattedDateWithFormat:@"yyyy-MM-dd"];
                   
                    if (![appointDate isEarlierThan:[NSDate dateWithString:[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] formatString:@"yyyy-MM-dd"]]) {
                        //日期早于保存的日期就不更新
                        dispatch_group_enter(group);
                        ZPLog(@"group %ld start",i);
                        [manage getStepCountWithDateString:dateString complete:^(double value, NSError * _Nonnull error) {
                            if (!error && value != 0) {
                                ZPLog(@"时间:%@-->步数:%.0f",dateString, value);
                                [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/common/customer/steps" andHTTPMethod:@"PUT" andDict:@{@"stepsCount":[NSNumber numberWithInteger:value],@"stepsDate":dateString} success:^(NSDictionary *response) {
                                    ZPLog(@"group %ld finish",i);
                                    dispatch_group_leave(group);
                                } failed:^(NSError *error) {
                                    ZPLog(@"group %ld finish",i);
                                    dispatch_group_leave(group);
                                }];
                            } else {
                                dispatch_group_leave(group);
                            }
                        }];
                    }
                    
                }
                
            } else {
                for (NSInteger i = 0; i<=days; i++) {
                    NSDate *appointDate;    // 指定日期声明
                    appointDate = [currentDate initWithTimeIntervalSinceNow: -(oneDay * i)];
                    ZPLog(@"多少天前%@",[appointDate formattedDateWithFormat:@"yyyy-MM-dd"]);
                    //               NSString *dateString = [[NSDate dateWithYear:year month:month day:i] formattedDateWithFormat:@"yyyy-MM-dd"];
                    NSString *dateString = [appointDate formattedDateWithFormat:@"yyyy-MM-dd"];
                    
                    dispatch_group_enter(group);
                    ZPLog(@"group %ld start",i);
                    [manage getStepCountWithDateString:dateString complete:^(double value, NSError * _Nonnull error) {
                        if (!error && value != 0) {
                            ZPLog(@"时间:%@-->步数:%.0f",dateString, value);
                            [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/common/customer/steps" andHTTPMethod:@"PUT" andDict:@{@"stepsCount":[NSNumber numberWithInteger:value],@"stepsDate":dateString} success:^(NSDictionary *response) {
                                ZPLog(@"group %ld finish",i);
                                dispatch_group_leave(group);
                            } failed:^(NSError *error) {
                                ZPLog(@"group %ld finish",i);
                                dispatch_group_leave(group);
                            }];
                        } else{
                            dispatch_group_leave(group);
                        }
                    }];
                }
                
            }
            
           
            // group notify
            dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                ZPLog(@"group finished");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [kUSER_DEFAULT setValue:[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"] forKey:@"stepsUpdateTime"];
                    [kUSER_DEFAULT synchronize];
                    [MBProgressHUD hideHUD];
                });
            });
            
        } else {
            ZPLog(@"HealthKitManage fail");
        }
    }];
    }
}

/*
 6、里程：女：1步=0.0006962公里
 
 男：1步=0.00075015公里
 
 里程=步数*步公里数（小数点保留两位，四舍五入）
 
 ≈绕操场x圈：里程*1000/400（小数点后保留1位，四舍五入）
 
 8、热量：1步=0.03620225卡
 
 消耗=步数*步数卡路里（取整数，四舍五入）
 
 ≈X罐可乐的热量：消耗/141.9(整数四舍五入)
 */

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
    }
    self.model = model;
    
}

- (void)historySteps {
    UHHistoryStepsController *historyControl = [[UHHistoryStepsController alloc] init];
    [self.navigationController pushViewController:historyControl animated:YES];
}

- (NSInteger)handleLi:(double)steps {
    if(steps >0) {
        return floorf(steps/100);
    }
    return 0;
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
    
    return 4;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UHStepCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHStepCircleCell class])];
        cell.model = self.model;
        cell.updateStepsBlock = ^{
            [self update];
        };
        return cell;
    }
    UHCommonStepCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCommonStepCell class])];
    cell.indexPath = indexPath.row-1;
    cell.model = self.model;
    cell.title = self.Items[indexPath.row-1][@"iconTitle"];
    cell.iconName = self.Items[indexPath.row-1][@"iconImageName"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 导航栏设置
- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY {
    CGFloat alpha = offsetY / 100.0;
    ZPLog(@"%f",alpha);
    self.navigationController.navigationBar.translucent = alpha <1 ?YES:NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,alpha >= 0 ? alpha : 0),RGBA(99,205,255,alpha >= 0 ? alpha : 0)]] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)itemBackgroundImage {
    return [[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(30, 30)] zp_cornerImageWithSize:CGSizeMake(30, 30) fillColor:[UIColor clearColor]];
}

//绘制对象背景的渐变色特效
- (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count > 1) {
        //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CGRect rect=CGRectMake(0,0, 1, 1);
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于按钮的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = rect;
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的背景色
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        //使用UIColor的如下方法，将字体颜色设为gradientImage模式，这样就可以将渐变色填充到背景色上了，同理可以设置按钮各状态的不同显示效果
        return gradientImage;
    }
    return nil;
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

#pragma mark - -界面的消失与出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,1),RGBA(99,205,255,1)]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
}

- (NSArray<NSDictionary *> *)Items {
    return @[@{@"iconImageName" : @"step_run_icon", @"iconTitle" : @"健康目标"},
             @{@"iconImageName" : @"step_footground_icon", @"iconTitle" : @"运动里程"},
             @{@"iconImageName" : @"step_heat_icon", @"iconTitle" : @"运动消耗"}];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHCommonStepCell class] forCellReuseIdentifier:NSStringFromClass([UHCommonStepCell class])];
        [_tableView registerClass:[UHStepCircleCell class] forCellReuseIdentifier:NSStringFromClass([UHStepCircleCell class])];
    }
    return _tableView;
}
@end
