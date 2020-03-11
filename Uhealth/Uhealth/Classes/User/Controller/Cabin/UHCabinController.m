//
//  UHCabinController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCabinController.h"

#import "UHCabinDetailModel.h"
#import "UHNurseModel.h"

#import "UHNurseCell.h"
#import "UHCarbinTitleCell.h"
#import "UHCarbinImgCell.h"
#import "UHCarbinServiceCell.h"

#import "UHBannerHtmlWebController.h"
@interface UHCabinController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;


@property (nonatomic, assign) CGFloat scrollOffsetY;
@end

@implementation UHCabinController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self initData];
}

- (void)initAll {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initData {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cabin/detail" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            UHCabinDetailModel *cabinDetailModel = [UHCabinDetailModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            weakSelf.model = cabinDetailModel;
            weakSelf.title = cabinDetailModel.healthCabinName;
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHCabinController class]];
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
    
    return self.data.count+3;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
    if (indexPath.row == 0) {
        UHNurseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHNurseCell class])];
        cell.model = self.model;
        cell.contactNurseBlock = ^(UHNurseModel *model) {
            if (model.nursePhone && model.nursePhone.length) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.nursePhone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [weakSelf.view addSubview:callWebview];
            }
        };
        return cell;
    } else if (indexPath.row == 1) {
        UHCarbinTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCarbinTitleCell class])];
        cell.dict = self.data[0];
        return cell;
    } else if (indexPath.row == 2) {
        UHCarbinImgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCarbinImgCell class])];
        cell.model = self.model;
        return  cell;
    } else if (indexPath.row == 3) {
        UHCarbinTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCarbinTitleCell class])];
        cell.dict = self.data[1];
        return cell;
    }
    UHCarbinServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCarbinServiceCell class])];
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //244
        return ZPHeight(254.0f);
    } else if (indexPath.row == 2) {
        return ZPHeight(70.0f);
    } else if (indexPath.row == 4) {
        return ZPHeight(120.0f);
    }
    return ZPHeight(47.0f);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.scrollOffsetY = offsetY;
    [self changeNavigationBarStyleWhenScroll:offsetY];
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




- (void)cabinIntroductionEvent {
    UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
    htmlWebControl.url = [NSString stringWithFormat:@"%@/ios/html/index.html?type=HUTDETAIL&imgUrl=%@",ZPBaseUrl,self.model.cabinDetail];
    htmlWebControl.titleString = @"小屋详情";
    ZPLog(@"小屋地址:%@", htmlWebControl.url );
    [self.navigationController pushViewController:htmlWebControl animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHCarbinTitleCell class] forCellReuseIdentifier:NSStringFromClass([UHCarbinTitleCell class])];
        [_tableView registerClass:[UHCarbinImgCell class] forCellReuseIdentifier:NSStringFromClass([UHCarbinImgCell class])];
        [_tableView registerClass:[UHCarbinServiceCell class] forCellReuseIdentifier:NSStringFromClass([UHCarbinServiceCell class])];
         [_tableView registerClass:[UHNurseCell class] forCellReuseIdentifier:NSStringFromClass([UHNurseCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZPHeight(116))];
        
        UIButton *btn = [UIButton new];
        [footView addSubview:btn];
        btn.sd_layout
        .centerYEqualToView(footView)
        .centerXEqualToView(footView)
        .widthIs(ZPWidth(190))
        .heightIs(ZPHeight(16));
        [btn setTitle:@">>点击进入健康小屋详情介绍" forState:UIControlStateNormal];
        [btn setTitleColor:ZPMyOrderDetailValueFontColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(14)];
        [btn addTarget:self action:@selector(cabinIntroductionEvent) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

- (NSArray *)data {
    if (!_data) {
        _data =@[@{@"icon":@"me_carbinImg_icon",@"title":@"小屋内景，功能配备"},@{@"icon":@"me_carbinService_icon",@"title":@"小屋特色服务"}];
    }
    return _data;
}
@end
