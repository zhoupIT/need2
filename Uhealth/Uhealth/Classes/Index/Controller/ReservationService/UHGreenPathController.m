//
//  UHGreenPathController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/10/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGreenPathController.h"
#import "SDCycleScrollView.h"
#import "UHGreenPathCell.h"

#import "UHBannerModel.h"
#import "UHHealthNewsModel.h"
#import "UHHealthWindModel.h"
#import "UHCommodity.h"

#import "UHHealthNewsWebViewController.h"
#import "UHHealthWindWebViewController.h"
#import "UHOrderDetailController.h"
#import "UHBannerHtmlWebController.h"
#import "UHLivingBroadcastFromBannerController.h"
#import "UHGreenPathReservationSerController.h"
#import "UHReservationServiceController.h"
#import "UHHelpCenterController.h"
@interface UHGreenPathController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *bannerDatas;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *items;

@property (nonatomic,strong) UHImg *introductionImg;//服务介绍
@property (nonatomic,strong) UHImg *processImg;
@end

@implementation UHGreenPathController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self initData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initAll {
    self.title = @"绿色通道";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleDone target:self action:@selector(helpCenter)];
}

- (void)initData {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/information",ZPBaseUrl] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.bannerDatas = [UHBannerModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"bannerList"]];
                weakSelf.introductionImg = [UHImg mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"introductionImg"]];
                weakSelf.processImg = [UHImg mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"processImg"]];
                NSMutableArray *tempArray = [NSMutableArray array];
                for (UHBannerModel *bannerModel in weakSelf.bannerDatas) {
                    [tempArray addObject:bannerModel.banner];
                }
                weakSelf.cycleScrollView.imageURLStringsGroup = tempArray;
                [weakSelf.tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHGreenPathReservationSerController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}


- (void)helpCenter {
    UHHelpCenterController *helpControl = [[UHHelpCenterController alloc] init];
    [self.navigationController pushViewController:helpControl animated:YES];
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
    
    return 2;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHGreenPathCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHGreenPathCell class])];
    cell.titleStr = self.items[indexPath.row][@"titleStr"];
    cell.titleBtnStr = self.items[indexPath.row][@"titleBtnStr"];
    cell.titleBtnImgStr = self.items[indexPath.row][@"titleBtnImgStr"];
    cell.btnDidClickBlock = ^(UIButton * _Nonnull btn) {
        if ([btn.titleLabel.text containsString:@"电话"]) {
            [self callAction];
        } else {
            UHReservationServiceController *control = [[UHReservationServiceController alloc] init];
            control.processImg = self.processImg;
            [self.navigationController pushViewController:control animated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)callAction {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-656-0320"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZPHeight(50.f);
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat w = SCREEN_WIDTH;
    CGFloat height = 0;
    if ( w <= self.introductionImg.width) {
        height = (w / self.introductionImg.width) * self.introductionImg.height;
    } else{
        height = self.introductionImg.height;
    }
    return ZPHeight(height+10);
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    contentView.backgroundColor = KControlColor;
    UIImageView *view=[UIImageView new];
    [contentView addSubview:view];
    view.sd_layout.spaceToSuperView(UIEdgeInsetsMake(ZPHeight(10), 0, 0, 0));
    view.backgroundColor = [UIColor clearColor];
    [view sd_setImageWithURL:[NSURL URLWithString:self.introductionImg.url] placeholderImage:[UIImage imageNamed:@"placeholder_cart"]];
    return contentView;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    /*
     bannerType的类型
     UHEALTH_DIRECTION     健康风向
     UHEALTH_INFORMATION   健康资讯
     COMMONDITY            商品
     LINK                  链接
     null                  单纯图片
     */
    /*
    UHBannerModel *model = self.bannerDatas[index];
    if ([model.bannerType.name isEqualToString:@"UHEALTH_INFORMATION"]) {
        
        UHHealthNewsWebViewController *webView = [[UHHealthNewsWebViewController alloc] init];
        //跳转url
        webView.mainBody = [NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.bannerAim];
        ZPLog(@"跳转资讯文章ID:%@",webView.mainBody);
        UHHealthNewsModel *healthNewsModel = [[UHHealthNewsModel alloc] init];
        healthNewsModel.informationId = model.bannerAim;;
        webView.healthNewsModel = healthNewsModel;
        webView.bannerAim = model.bannerAim;
        webView.enterStatusType = ZPHealthEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"UHEALTH_DIRECTION"]) {
        UHHealthWindWebViewController *windWebViewControl = [[UHHealthWindWebViewController alloc] init];
        windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.bannerAim];
        ZPLog(@"跳转风向文章ID:%@",windWebViewControl.urlStr);
        UHHealthWindModel *windModel =  [[UHHealthWindModel alloc] init];
        windModel.directionId = model.bannerAim;;
        windWebViewControl.windModel = windModel;
        windWebViewControl.bannerAim = model.bannerAim;
        windWebViewControl.enterStatusType = ZPWindEnterStatusTypeBanner;
        [self.navigationController pushViewController:windWebViewControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"COMMONDITY"]) {
        ZPLog(@"跳转商品ID:%@",model.bannerAim);
        UHOrderDetailController *orderDetailControl = [[UHOrderDetailController alloc] init];
        UHCommodity *commodity = [[UHCommodity alloc] init];
        commodity.commodityId = [model.bannerAim integerValue];
        orderDetailControl.commodity = commodity;
        orderDetailControl.enterStatusType = ZPOrderEnterStatusTypeBanner;
        [self.navigationController pushViewController:orderDetailControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LINK"]) {
        ZPLog(@"跳转链接:%@",model.bannerAim);
        UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
        
        htmlWebControl.url = model.bannerAim;
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LONG_IMAGE"]) {
        ZPLog(@"跳转长图:%@",[NSString stringWithFormat:@"%@/ios/html/index.html?type=HUTDETAIL&imgUrl=%@",ZPBaseUrl,model.bannerAim]);
        UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
        htmlWebControl.url = [NSString stringWithFormat:@"%@/ios/html/index.html?type=HUTDETAIL&imgUrl=%@",ZPBaseUrl,model.bannerAim];
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LECTURE_ROOM"]) {
        UHLivingBroadcastFromBannerController *livinglectureControl = [[UHLivingBroadcastFromBannerController alloc] init];
        livinglectureControl.ID = model.bannerAim;
        [self.navigationController pushViewController:livinglectureControl animated:YES];
    }
     */
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHGreenPathCell class] forCellReuseIdentifier:NSStringFromClass([UHGreenPathCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZPHeight(150)) imageURLStringsGroup:@[]];
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.delegate = self;
        _cycleScrollView.currentPageDotImage = [UIImage imageWithColor:ZPMyOrderDetailValueFontColor size:CGSizeMake(15, 5) cornerRadius:3];
        _cycleScrollView.pageDotImage = [UIImage imageWithColor:RGBA(0, 0, 0, 0.34) size:CGSizeMake(15, 5) cornerRadius:3];
    }
    return _cycleScrollView;
}

- (NSMutableArray *)bannerDatas {
    if (!_bannerDatas) {
        _bannerDatas = [NSMutableArray array];
    }
    return _bannerDatas;
}

- (NSArray<NSDictionary *> *)items {
    return @[@{@"titleStr" : @"绿通电话预约", @"titleBtnStr" : @"电话预约", @"titleBtnImgStr" : @"greenPath_phone_icon"},
             @{@"titleStr" : @"绿通在线预约", @"titleBtnStr" : @"在线预约", @"titleBtnImgStr" : @"greenPath_reser_icon"}];
}
@end
