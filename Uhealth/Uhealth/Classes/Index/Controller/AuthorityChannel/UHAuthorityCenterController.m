//
//  UHAuthorityCenterController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHAuthorityCenterController.h"
#import "SDCycleScrollView.h"
#import "UHAuthorityCenterCell.h"
#import "UHChannelDoctorModel.h"
#import "UHBannerModel.h"
#import "UHAdvisoryChannelModel.h"
#import "UHHealthNewsWebViewController.h"
#import "UHHealthNewsModel.h"
#import "UHHealthWindWebViewController.h"
#import "UHHealthWindModel.h"
#import "UHOrderDetailController.h"
#import "UHCommodity.h"
#import "UHBannerHtmlWebController.h"
#import "UHAuthorityDoctorController.h"
#import "UHLivingBroadcastFromBannerController.h"
@interface UHAuthorityCenterController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *bannerDatas;
@property (nonatomic,strong) NSMutableArray *doctorDatas;
@end

@implementation UHAuthorityCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = self.channelModel.channelType.text;
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.tableHeaderView = self.cycleScrollView;
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"channel/detail" parameters:@{@"channelId":self.channelModel.ID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.bannerDatas = [UHBannerModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"banner"]];
                weakSelf.doctorDatas  = [UHChannelDoctorModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"doctor"]];
                NSMutableArray *tempArray = [NSMutableArray array];
                for (UHBannerModel *bannerModel in weakSelf.bannerDatas) {
                    [tempArray addObject:bannerModel.banner];
                }
                weakSelf.cycleScrollView.imageURLStringsGroup = tempArray;
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHAuthorityCenterController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"channel/detail" parameters:@{@"offset":[NSNumber numberWithInteger:self.doctorDatas.count],@"channelId":self.channelModel.ID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHChannelDoctorModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"doctor"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.doctorDatas addObjectsFromArray:arrays];
                    [tableView reloadData];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHAuthorityCenterController class]];
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
    
    return self.doctorDatas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHAuthorityCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHAuthorityCenterCell class])];
    cell.model = self.doctorDatas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      return [tableView cellHeightForIndexPath:indexPath model:self.doctorDatas[indexPath.row] keyPath:@"model" cellClass:[UHAuthorityCenterCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHAuthorityDoctorController *control = [[UHAuthorityDoctorController alloc] init];
    control.doctorModel = self.doctorDatas[indexPath.row];
    [self.navigationController pushViewController:control animated:YES];
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
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZPHeight(200)) imageURLStringsGroup:@[]];
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.delegate = self;
        _cycleScrollView.currentPageDotImage = [UIImage imageWithColor:ZPMyOrderDetailValueFontColor size:CGSizeMake(15, 5) cornerRadius:3];
        _cycleScrollView.pageDotImage = [UIImage imageWithColor:RGBA(0, 0, 0, 0.34) size:CGSizeMake(15, 5) cornerRadius:3];
    }
    return _cycleScrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHAuthorityCenterCell class] forCellReuseIdentifier:NSStringFromClass([UHAuthorityCenterCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
