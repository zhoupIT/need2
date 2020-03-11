//
//  UHViewController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHViewController.h"
#import "TTTAttributedLabel.h"
#import "iOS-Echarts.h"
#import "UHMyGuaranteeController.h"
#import "UHHealthTestController.h"
#import "UHConsultDoctorController.h"
#import "UHReservationServiceController.h"
#import "UHHealthWindController.h"
#import "UHMyPlanController.h"
#import "UHUserModel.h"
#import "SDCycleScrollView.h"
#import "UHHealthNewsMainController.h"

#import "UHLoginController.h"

#import "UHNavigationController.h"

#import "UHBindingCompanyController.h"

#import "UHChronicDiseaseManageMentController.h"

#import "SessionListViewController.h"

#import "UHPhysicalManageController.h"

#import "UHHealthNewsModel.h"

#import "UHHealthNewsWebViewController.h"

#import "UHBannerWebController.h"

#import "UHConsultController.h"
#import "DiseaseMatchViewController.h"

#import "UHGetScore.h"

#import "UHHealthTestWebViewController.h"

#import "UHBannerHtmlWebController.h"
#import "WZLBadgeImport.h"
#import "UHRadarPopTableView.h"
#import "UHBannerModel.h"
#import "UHHealthWindWebViewController.h"
#import "UHOrderDetailController.h"
#import "UHHealthWindModel.h"
#import "UHCommodity.h"

#import "UHHealthNewsMoreImagesCell.h"
#import "UHHealthNewsModel.h"
#import "UHHealthNewsOneImageCell.h"

#import "UHAuthorityChannelCell.h"

#import "UHAuthorityChannelController.h"
#import "UHAdvisoryChannelModel.h"
#import "UHAuthorityCenterController.h"
#import "EBBannerView.h"
#import "UHLivingBroadcastFromBannerController.h"
@interface UHViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) SDCycleScrollView *bannerImageView;
//交通银行
@property (nonatomic,strong) UIButton *bcmButton;
//个人保障
@property (nonatomic,strong) UIButton *personalSecurityButton;
//我爱我家
@property (nonatomic,strong) UIImageView *loveHomeImageView;
//雷达图
//@property (nonatomic, strong) UIView *chartView;
@property (nonatomic,strong) NSArray *options;
@property (nonatomic, assign) BOOL shouldHideData;

//慢病管理
@property (nonatomic,strong) UIButton *managerButton;

@property (nonatomic,strong) UILabel *tipLabel1;
@property (nonatomic,strong) UILabel *tipLabel2;
@property (nonatomic,strong) UILabel *tipLabel3;
@property (nonatomic,strong) UILabel *tipLabel4;
@property (nonatomic,strong) UIButton *moreScoreButton;

@property (nonatomic,strong) UILabel *tipLabel1Value;
@property (nonatomic,strong) UILabel *tipLabel2Value;
@property (nonatomic,strong) UILabel *tipLabel3Value;
@property (nonatomic,strong) UILabel *tipLabel4Value;


//间距
@property (nonatomic,strong) UIView *grayView;


//健康资讯
@property (nonatomic,strong) UIView *hotNewView;

@property (nonatomic,strong) UIView *blueView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic, strong) PYEchartsView *kEchartView;


@property (nonatomic,copy) NSString *mainBody;
@property (nonatomic,strong) UHHealthNewsModel *healthNewsModel;


@property (nonatomic,strong) NSMutableArray *scoreTitleData;
@property (nonatomic,strong) NSMutableArray *scoreData;
@property (nonatomic,strong) NSMutableArray *radarData;


@property (nonatomic,strong) UIButton *rightItem;

//弹框----->score的数组
@property (nonatomic,strong) NSArray *scoreShowDatas;
//弹框----->总分
@property (nonatomic,copy) NSString *totalScore;
//banner图的模型集合
@property (nonatomic,strong) NSArray *bannerArray;

//健康资讯
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *newsDatas;


//权威频道

//间距
@property (nonatomic,strong) UIView *authoritygrayView;
@property (nonatomic,strong) UIView *authorityblueView;
@property (nonatomic,strong) UILabel *authoritytitleLabel;
@property (nonatomic,strong) UIButton *authoritymoreButton;
@property (nonatomic,strong) UIView *authoritylineView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *channelDatas;

@property (nonatomic,strong) UIView *tempgrayView;
@end

@implementation UHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getAppVersion];
//    WEAK_SELF(weakSelf);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getHeadBanner];
//    });
    //监听RegistrationID
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadRegistrationID) name:kJPFNetworkDidLoginNotification object:nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
         UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        if (model.companyName.length  && model.welcomeMessage.length && (![kUSER_DEFAULT objectForKey:model.ID] || [kUSER_DEFAULT objectForKey:model.ID] == NO)) {
            [self popImgWithUrl:model.welcomeMessage];
            //保存个人id为Yes 说明弹过了
            [kUSER_DEFAULT setBool:YES forKey:model.ID];
            [kUSER_DEFAULT synchronize];
        }
    }
}

- (void)setupUI {
    
    self.scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
   self.bannerImageView = [SDCycleScrollView new];
    self.bannerImageView.delegate = self;
//    self.bannerImageView.placeholderImage = [UIImage imageNamed:@"placeholder_orderMain"];
    self.bannerImageView.autoScrollTimeInterval = 3;
    [self.scrollView addSubview:self.bannerImageView];
   
    

    self.bannerImageView.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .heightIs(ZPHeight(210));
    
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"index_noti_icon"] forState:UIControlStateNormal];
    
    [self.bannerImageView addSubview:btn];
    btn.sd_layout
    .rightSpaceToView(self.bannerImageView, 15)
    .topSpaceToView(self.bannerImageView, IS_IPhoneX?42:20)
    .heightIs(20)
    .widthIs(20);
    [btn addTarget:self action:@selector(chatInfoList) forControlEvents:UIControlEventTouchUpInside];
    self.rightItem = btn;
    
    self.bcmButton = [UIButton new];
    self.personalSecurityButton = [UIButton new];
    [self.scrollView addSubview:self.bcmButton];
    [self.scrollView addSubview:self.personalSecurityButton];
     self.bcmButton.sd_layout
     .leftSpaceToView(self.scrollView, 16)
     .heightIs(35)
     .topSpaceToView(self.bannerImageView, 18)
     .widthIs((SCREEN_WIDTH-2*16-10)*0.5);
     
     self.personalSecurityButton.sd_layout
     .leftSpaceToView(self.bcmButton, 10)
     .rightSpaceToView(self.scrollView, 20)
     .topEqualToView(self.bcmButton)
     .heightIs(35);
     
    [self.bcmButton setTitle:@"企业入口" forState:UIControlStateNormal];
    [self.bcmButton setBackgroundColor:RGB(78, 178, 255)];
    self.bcmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.bcmButton.layer.cornerRadius = 4;
    self.bcmButton.layer.masksToBounds = YES;
    [self.bcmButton addTarget:self action:@selector(companyEntanceAction:) forControlEvents:UIControlEventTouchUpInside];
     
     [self.personalSecurityButton setTitle:@"个人保障" forState:UIControlStateNormal];
     [self.personalSecurityButton setBackgroundColor:RGB(78, 178, 255)];
     self.personalSecurityButton.titleLabel.font = [UIFont systemFontOfSize:15];
     self.personalSecurityButton.layer.cornerRadius = 4;
     self.personalSecurityButton.layer.masksToBounds = YES;
     [self.personalSecurityButton addTarget:self action:@selector(myGuarantee) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tempbtn;
    NSArray *titleArray = @[@"健康自测",@"疾病自查",@"身心咨询",@"绿色通道",@"健康风向"];
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton new];
        [self.scrollView addSubview:btn];
        if (i==0) {
            btn.sd_layout
            .leftSpaceToView(self.scrollView, 15)
            .heightIs(70)
            .topSpaceToView(self.bcmButton, 18)
            .widthIs((SCREEN_WIDTH-15*2-4*22)/5);
            //(SCREEN_WIDTH-15*2-4*22)/5
            
        } else {
            btn.sd_layout
            .leftSpaceToView(tempbtn, 22)
            .heightIs(70)
            .topSpaceToView(self.bcmButton, 18)
            .centerYEqualToView(tempbtn)
            .widthIs((SCREEN_WIDTH-15*2-4*22)/5);
            //
        }
        btn.imageView.sd_layout.centerXEqualToView(btn);
        btn.titleLabel.sd_layout.centerXEqualToView(btn)
        .leftSpaceToView(btn, 0)
        .widthIs((SCREEN_WIDTH-15*2-4*22)/5);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateHighlighted];
       
        [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:12];
        
        btn.tag = 10000+i;
        [btn addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        tempbtn = btn;
    }
    
    self.loveHomeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_loveHome"]];
//    [self.scrollView addSubview:self.loveHomeImageView];
    self.loveHomeImageView.sd_layout
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(ZPHeight(65))
    .topSpaceToView(tempbtn, 20);
    
    [self.scrollView addSubview:self.tempgrayView];
    self.tempgrayView.sd_layout
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(10)
    .topSpaceToView(tempbtn, 20);
    
    //雷达图
    [self setupRadar];
    //慢病管理
    [self setupManager];
    
    self.authoritygrayView = [UIView new];
    [self.scrollView addSubview:self.authoritygrayView];
    self.authoritygrayView.backgroundColor = RGB(242, 242, 242);
    self.authoritygrayView.sd_layout
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(10)
    .topSpaceToView(@[self.kEchartView,self.moreScoreButton], 20);
    //权威频道
    [self setupAuthority];
    
    self.grayView = [UIView new];
    [self.scrollView addSubview:self.grayView];
    self.grayView.backgroundColor = RGB(242, 242, 242);
    self.grayView.sd_layout
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(10)
    .topSpaceToView(self.collectionView, 0);
    //健康资讯
    [self setupHealthNews];
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.tableView bottomMargin:10];
}

//权威频道
- (void)setupAuthority {
    self.authorityblueView = [UIView new];
    [self.scrollView addSubview:self.authorityblueView];
    self.authorityblueView.sd_layout
    .leftEqualToView(self.scrollView)
    .heightIs(16)
    .widthIs(3)
    .topSpaceToView(self.authoritygrayView, 10);
    self.authorityblueView.backgroundColor = RGB(78, 178, 255);
    
    self.authoritytitleLabel = [UILabel new];
    [self.scrollView addSubview:self.authoritytitleLabel];
    self.authoritytitleLabel.sd_layout
    .leftSpaceToView(self.authorityblueView, 13)
    .heightIs(15)
    .centerYEqualToView(self.authorityblueView)
    .widthIs(70);
    self.authoritytitleLabel.textColor = RGB(74, 74, 74);
    self.authoritytitleLabel.font = [UIFont systemFontOfSize:15];
    self.authoritytitleLabel.text = @"权威频道";
    
    self.authoritymoreButton = [UIButton new];
    [self.scrollView addSubview:self.authoritymoreButton];
    self.authoritymoreButton.sd_layout
    .rightSpaceToView(self.scrollView, 15)
    .heightIs(12)
    .centerYEqualToView(self.authorityblueView)
    .widthIs(35);
    [self.authoritymoreButton setImage:[UIImage imageNamed:@"arrow_more_icon"] forState:UIControlStateNormal];
    [self.authoritymoreButton setTitle:@"更多" forState:UIControlStateNormal];
    [self.authoritymoreButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    self.authoritymoreButton.titleLabel.font = [UIFont fontWithName:ZPPFSCLight size:12];
    [self.authoritymoreButton addTarget:self action:@selector(moreAuthorityChannel) forControlEvents:UIControlEventTouchUpInside];
    [self.authoritymoreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:7];
    
    [self.scrollView addSubview:self.authoritylineView];
    self.authoritylineView.sd_layout
    .topSpaceToView(self.authorityblueView, 10)
    .heightIs(0.5)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView);
    
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.sd_layout
    .topSpaceToView(self.authorityblueView, 20)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(140);
}

//健康资讯界面UI
- (void)setupHealthNews {
    self.blueView = [UIView new];
    [self.scrollView addSubview:self.blueView];
    self.blueView.sd_layout
    .leftEqualToView(self.scrollView)
    .heightIs(16)
    .widthIs(3)
    .topSpaceToView(self.grayView, 10);
    self.blueView.backgroundColor = RGB(78, 178, 255);
    
    self.titleLabel = [UILabel new];
    [self.scrollView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.blueView, 13)
    .heightIs(15)
    .centerYEqualToView(self.blueView)
    .widthIs(70);
    self.titleLabel.textColor = RGB(74, 74, 74);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"健康资讯";
    
    self.moreButton = [UIButton new];
    [self.scrollView addSubview:self.moreButton];
     self.moreButton.sd_layout
     .rightSpaceToView(self.scrollView, 15)
     .heightIs(12)
     .centerYEqualToView(self.blueView)
     .widthIs(35);
    [self.moreButton setImage:[UIImage imageNamed:@"arrow_more_icon"] forState:UIControlStateNormal];
    [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    self.moreButton.titleLabel.font = [UIFont fontWithName:ZPPFSCLight size:12];
    [self.moreButton addTarget:self action:@selector(moreHealthNews) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:7];
    
    [self.scrollView addSubview:self.lineView];
    self.lineView.sd_layout
    .topSpaceToView(self.blueView, 10)
    .heightIs(0.5)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView);
    
    [self.scrollView addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.blueView, 20)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(10);
}

- (void)setupManager {
    
    self.managerButton = [UIButton new];
    [self.scrollView addSubview:self.managerButton];
    self.managerButton.sd_layout
    .rightSpaceToView(self.scrollView,IS_IPHONE5?11:31*[Utils ZPDeviceWidthRation])
    .heightIs(30)
    .widthIs(100)
    .topSpaceToView(self.tempgrayView, 30);
    [self.managerButton setTitle:@"身心管理" forState:UIControlStateNormal];
    [self.managerButton setBackgroundColor:RGB(78,178,255)];
    [self.managerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.managerButton.layer.cornerRadius = 15;
    self.managerButton.layer.masksToBounds = YES;
    self.managerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.managerButton addTarget:self action:@selector(chronicDiseaseManageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.managerButton setImage:[UIImage imageNamed:@"arrows_more_icon"] forState:UIControlStateNormal];
    [self.managerButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:9];
    
    self.tipLabel1 = [UILabel new];
    self.tipLabel1.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.tipLabel1];
    self.tipLabel2 = [UILabel new];
    self.tipLabel2.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.tipLabel2];
    self.tipLabel3 = [UILabel new];
    self.tipLabel3.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.tipLabel3];
    self.tipLabel4 = [UILabel new];
    self.tipLabel4.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.tipLabel4];
    ZPLog(@"注意:%f",30*[Utils ZPDeviceWidthRation]);
    self.tipLabel1.sd_layout
    .leftEqualToView(self.managerButton)
    .heightIs(13)
    .widthIs(48)
    .topSpaceToView(self.managerButton, 14);
    
    self.tipLabel2.sd_layout
    .leftEqualToView(self.managerButton)
    .heightIs(13)
    .widthIs(48)
    .topSpaceToView(self.tipLabel1, 11);
    
    self.tipLabel3.sd_layout
    .leftEqualToView(self.managerButton)
    .heightIs(13)
    .widthIs(48)
    .topSpaceToView(self.tipLabel2, 11);
    
    self.tipLabel4.sd_layout
    .leftEqualToView(self.managerButton)
    .heightIs(13)
    .widthIs(48)
    .topSpaceToView(self.tipLabel3, 11);
     self.tipLabel1.font = [UIFont fontWithName:ZPPFSCLight size:13];
     self.tipLabel2.font = [UIFont fontWithName:ZPPFSCLight size:13];
     self.tipLabel3.font = [UIFont fontWithName:ZPPFSCLight size:13];
     self.tipLabel4.font = [UIFont fontWithName:ZPPFSCLight size:13];
    
    self.tipLabel1.textColor = ZPMyOrderDetailValueFontColor;
    self.tipLabel2.textColor = ZPMyOrderDetailValueFontColor;
    self.tipLabel3.textColor = ZPMyOrderDetailValueFontColor;
    self.tipLabel4.textColor = ZPMyOrderDetailValueFontColor;
    
    self.tipLabel1.text = @"情绪:";
    self.tipLabel2.text = @"睡眠:";
    self.tipLabel3.text = @"疼痛:";
    self.tipLabel4.text = @"疑病:";
    self.tipLabel4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllScore)];
    [_tipLabel4Value addGestureRecognizer:tap];
    [self.tipLabel4 addGestureRecognizer:tap];
    
    [self.scrollView sd_addSubviews:@[self.tipLabel1Value,self.tipLabel2Value,self.tipLabel3Value,self.tipLabel4Value]];
    self.tipLabel1Value.sd_layout
    .rightEqualToView(self.managerButton)
    .heightIs(13)
    .leftSpaceToView(self.tipLabel1, 0)
    .centerYEqualToView(self.tipLabel1);
    
    self.tipLabel2Value.sd_layout
    .rightEqualToView(self.managerButton)
    .heightIs(13)
    .leftSpaceToView(self.tipLabel2, 0)
    .centerYEqualToView(self.tipLabel2);
    
    self.tipLabel3Value.sd_layout
    .rightEqualToView(self.managerButton)
    .heightIs(13)
    .leftSpaceToView(self.tipLabel3, 0)
    .centerYEqualToView(self.tipLabel3);
    
    self.tipLabel4Value.sd_layout
    .rightEqualToView(self.managerButton)
    .heightIs(13)
    .leftSpaceToView(self.tipLabel4, 0)
    .centerYEqualToView(self.tipLabel4);
    
    
    
    [self.scrollView addSubview:self.moreScoreButton];
    self.moreScoreButton.sd_layout
    .topSpaceToView(self.tipLabel4, 13)
    .rightEqualToView(self.managerButton)
    .leftEqualToView(self.managerButton)
    .heightIs(13);
    self.moreScoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 31);
    self.moreScoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [self.moreScoreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:61];
    
}

- (void)setupRadar {
    self.kEchartView = [PYEchartsView new];
    [self.scrollView addSubview:self.kEchartView];
    self.kEchartView.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.tempgrayView, 18)
    .heightIs(167)
    .widthIs(210);
    [_kEchartView setOption:[self standardRadarOption]];
    [_kEchartView loadEcharts];
    
}

- (PYOption *)standardRadarOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.calculableEqual(YES).titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"").subtextEqual(@"");
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.showEqual(YES);
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .addPolar([PYPolar initPYPolarWithBlock:^(PYPolar *polar) {
            
            polar.splitNumberEqual(@4);
            polar.splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual([PYColor colorWithHexString:@"#72c2ff"]);
                }]);
            }]);
            
            polar.splitAreaEqual([PYSplitArea initPYSplitAreaWithBlock:^(PYSplitArea *splitArea) {
                splitArea.showEqual(YES);
                splitArea.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                    
                    areaStyle.colorEqual([PYColor colorWithHexString:@"#eff8ff"]);
                }]);
            }]);
            polar.axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
                
            }]);
            polar.indicatorEqual([[NSMutableArray alloc] initWithArray:@[
                                                                         @{ @"text": @"情绪", @"max": @3},
                                                                         @{ @"text": @"睡眠", @"max": @3},
                                                                         @{ @"text": @"焦虑", @"max": @3},
                                                                         @{ @"text": @"疼痛", @"max": @3},
                                                                         @{ @"text": @"性功能", @"max": @3},
                                                                         @{ @"text": @"满意度", @"max": @3},
                                                                         @{ @"text": @"疑病", @"max": @3},
                                                                         @{ @"text": @"社交", @"max": @3}
                                                                         ]]);
        }])
        .addSeries([PYRadarSeries initPYRadarSeriesWithBlock:^(PYRadarSeries *series) {
            series.addData(@{
                             @"value" : self.radarData,
                             @"name":@"身心管理"
                             })
            .typeEqual(PYSeriesTypeRadar).itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.colorEqual(PYRGBA(0,0,0,0));
                    itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                        lineStyle.colorEqual([PYColor colorWithHexString:@"#fff"]);
                        
                    }]).areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.colorEqual(@"(function (){var zrColor = zrender.tool.color;return zrColor.getLinearGradient(0, 0, 1000, 0,[[0, 'rgba(110,226,255,1)'],[0.8, 'rgba(78,178,255,1)']])})()");
                    }]);
                }]);
            }]);
            series.symbolEqual(PYSymbolNone);
        }]);
    }];
}

#pragma mark - 界面消失 显示
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
    [self getHotHealthInformation];
//    [self getHeadBanner];
    [self getAdvisoryChannel];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [self getUnreadMessage];
        
        UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        if (![model.companyName isEqualToString:@""]) {
            [self.bcmButton setTitle:model.companyName forState:UIControlStateNormal];
            [self getScoreNetWork];
        }
        if (![kUSER_DEFAULT objectForKey:@"registrationID"]) {
            [self uploadJPushID];
        }
    }
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
    
    return self.newsDatas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UHHealthNewsModel *model = self.newsDatas.count>0?self.newsDatas[indexPath.row]:nil;
    
    if (model.titleImgList.count == 1) {
        UHHealthNewsOneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthNewsOneImageCell class])];
        cell.model = model;
        return cell;
    }
    UHHealthNewsMoreImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthNewsMoreImagesCell class])];
    cell.model = model;
    return cell;
}


//设置最后一行的分割线边距为零
-(void)setLastCellSeperatorToLeft:(UITableViewCell *)cell
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHHealthNewsModel *model = self.newsDatas[indexPath.row];
    if (model.titleImgList.count == 1) {
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthNewsOneImageCell class] contentViewWidth:SCREEN_WIDTH];
    }
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthNewsMoreImagesCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHHealthNewsModel *model = self.newsDatas[indexPath.row];
    UHHealthNewsWebViewController *webView = [[UHHealthNewsWebViewController alloc] init];
    if ([ZPBaseUrl isEqualToString:@"http://192.168.8.20"]) {
        webView.mainBody = [NSString stringWithFormat:@"%@/h5/app/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.informationId];
    } else {
        webView.mainBody = [NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.informationId];
    }
    webView.healthNewsModel = model;
    [self.navigationController pushViewController:webView animated:YES];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(), ^{
            ZPLog(@"设置高度:%f",tableView.contentSize.height);
            tableView.sd_layout.heightIs(tableView.contentSize.height);
        });
    }
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UHAuthorityChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UHAuthorityChannelCell class]) forIndexPath:indexPath];
    cell.model = self.channelDatas[indexPath.row];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UHAdvisoryChannelModel *model = self.channelDatas[indexPath.row];
    if ([model.channelStatus.name isEqualToString:@"NORMAL"]) {
        UHAuthorityCenterController *authorityCenterControl = [[UHAuthorityCenterController alloc] init];
        authorityCenterControl.channelModel = model;
        [self.navigationController pushViewController:authorityCenterControl animated:YES];
    } else {
        [LEEAlert alert].config
        .LeeTitle(@"提醒")
        .LeeContent(model.channelStatus.text)
        .LeeAction(@"确认", ^{
        })
        .LeeClickBackgroundClose(YES)
        .LeeShow();
    }
}


#pragma mark - banner图点击的delegate
/** banner图片点击的回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    /*
     bannerType的类型
     UHEALTH_DIRECTION     健康风向
     UHEALTH_INFORMATION   健康资讯
     COMMONDITY            商品
     LINK                  链接
     null                  单纯图片
     */
    UHBannerModel *model = self.bannerArray[index];
    if ([model.bannerType.name isEqualToString:@"UHEALTH_INFORMATION"]) {
        
        UHHealthNewsWebViewController *webView = [[UHHealthNewsWebViewController alloc] init];
        //跳转url
        if ([ZPBaseUrl isEqualToString:@"http://192.168.8.20"]) {
            //测试环境
            webView.mainBody = [NSString stringWithFormat:@"%@/h5/app/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.bannerAim];
        } else {
            webView.mainBody = [NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.bannerAim];
        }
        ZPLog(@"跳转资讯文章ID:%@",webView.mainBody);
        UHHealthNewsModel *healthNewsModel = [[UHHealthNewsModel alloc] init];
        healthNewsModel.informationId = model.bannerAim;;
        webView.healthNewsModel = healthNewsModel;
        webView.bannerAim = model.bannerAim;
        webView.enterStatusType = ZPHealthEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"UHEALTH_DIRECTION"]) {
        UHHealthWindWebViewController *windWebViewControl = [[UHHealthWindWebViewController alloc] init];
        if ([ZPBaseUrl isEqualToString:@"http://192.168.8.20"]) {
            //测试环境
            windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/h5/app/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.bannerAim];
        } else {
            windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.bannerAim];
        }
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
        ZPLog(@"跳转长图:%@",[NSString stringWithFormat:@"%@/ios/html/index.html?id=%@&type=HOMEDETAIL",ZPBaseUrl,model.ID]);
        UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
        
        htmlWebControl.url = [NSString stringWithFormat:@"%@/ios/html/index.html?id=%@&type=HOMEDETAIL",ZPBaseUrl,model.ID];
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LECTURE_ROOM"]) {
        UHLivingBroadcastFromBannerController *livinglectureControl = [[UHLivingBroadcastFromBannerController alloc] init];
        livinglectureControl.ID = model.bannerAim;
        [self.navigationController pushViewController:livinglectureControl animated:YES];
    }
  
    /*
    if (index == 1) {
        UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
        htmlWebControl.url = bannerUrl;
        htmlWebControl.titleString = @"温馨家园 关心无限";
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    }else if(index == 2){
       //暂定
    } else {
        UHBannerWebController *webControl = [[UHBannerWebController alloc] init];
        webControl.pageindex = index;
        [self.navigationController pushViewController:webControl animated:YES];
    }
     */
}

#pragma mark - privite
//弹出欢迎图片
- (void)popImgWithUrl:(NSString *)urlStr {
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IS_IPHONE5?280:ZPWidth(280), 381)];
    
    //435
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, IS_IPHONE5?276:ZPWidth(276), 350)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [temp addSubview:iconView];
    
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 31, 31)];
    [closeBtn setImage:[UIImage imageNamed:@"close_pop_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [temp addSubview:closeBtn];
    
    closeBtn.sd_layout
    .centerXEqualToView(iconView);
    
    [LEEAlert alert].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = temp;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeBackGroundColor([UIColor clearColor])
    .LeeHeaderColor([UIColor clearColor])
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            animatingBlock(); //调用动画中Block
            
        } completion:^(BOOL finished) {
            
            animatedBlock(); //调用动画结束Block
        }];
        
    })
    .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            animatingBlock();
            
        } completion:^(BOOL finished) {
            
            animatedBlock();
        }];
        
    })
    .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type) {
        if (IS_IPHONE5) {
            return 280;
        }
        return ZPWidth(280);
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}


//判断app是否需要更新
- (void)getAppVersion {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"version" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            //            float data = [[response objectForKey:@"data"] floatValue];
            NSString *data = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"versionCode"]];
            ZPLog(@"服务器版本号:%@  app版本号:%@ ",data,PRODUCT_VERSION);
            //[PRODUCT_VERSION floatValue] < data
            NSString *pV = [NSString stringWithFormat:@"%@",PRODUCT_VERSION];
            if ([pV compare:data options:NSNumericSearch] == NSOrderedAscending) {
                [LEEAlert alert].config
                .LeeTitle(@"提醒")
                .LeeContent(@"App有新的版本可以下载,前去下载")
                .LeeCancelAction(@"取消", ^{
                    
                })
                .LeeAction(@"确认", ^{
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AppStoreUrl]];
                    [[UIApplication sharedApplication] openURL:url];
                })
                .LeeClickBackgroundClose(YES)
                .LeeShow();
            }
        } else {
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHViewController class]];
}

//获取banner
- (void)getHeadBanner {
    ZPLog(@"getHeadBanner");
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"banner" parameters:@{@"position":@"HEAD",@"launchPlatform":@"IOS"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        ZPLog(@"获取banner:%@",response);
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.bannerArray = [UHBannerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (UHBannerModel *model in weakSelf.bannerArray) {
                [tempArray addObject:model.banner];
            }
            weakSelf.bannerImageView.imageURLStringsGroup =tempArray;
        } else {
            
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
       
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        ZPLog(@"error:%@",error);
    } className:[UHViewController class]];
}

//获取权威频道
- (void)getAdvisoryChannel {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/channel" parameters:@{@"channelPosition":@"HOMEPAGE"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.channelDatas  = [UHAdvisoryChannelModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [weakSelf.collectionView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        ZPLog(@"%@",error);
    } className:[UHViewController class]];
}

//获取未读消息
- (void)getUnreadMessage {
    __weak typeof(self) weakSelf = self;
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/message" parameters:@{@"messageStatus":@"UNREAD"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSInteger num = [[[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"] integerValue];
            [weakSelf.rightItem showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHViewController class]];
}

//上传jpush的registrationID
- (void)uploadJPushID {
    WEAK_SELF(weakSelf);
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        ZPLog(@"------>registrationID: %@",[JPUSHService registrationID]);
        //上传极光registrationID给服务器
        [weakSelf uploadRegistrationID];
    }];
}

- (void)uploadRegistrationID {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH] && [JPUSHService registrationID]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/message/jpush/information",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        NSDictionary *msg = @{@"registrationId":[JPUSHService registrationID]};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            ZPLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        ZPLog(@"上传极光registrationID:%@给服务器成功",[JPUSHService registrationID]);
                        [kUSER_DEFAULT setValue:[JPUSHService registrationID] forKey:@"registrationID"];
                        [kUSER_DEFAULT synchronize];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 401){
                        //未登录页面
                        [self logout];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 402){
                        //清除登录信息
                        [self clearLoginInfo];
                        [LEEAlert alert].config
                        .LeeContent([dict objectForKey:@"message"])
                        .LeeAction(@"确认", ^{
                            UHLoginController *loginControl = [[UHLoginController alloc] init];
                            UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
                            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                        })
                        .LeeShow();
                        
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
        }] resume];
    }
}

//获取评分
- (void)getScoreNetWork {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"get/scores" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [weakSelf.scoreTitleData removeAllObjects];
            [weakSelf.scoreData removeAllObjects];
            NSArray *arrays = [UHGetScore mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            weakSelf.scoreShowDatas = arrays;
            
          
            for (UHGetScore *score in arrays) {
                [weakSelf.scoreTitleData addObject:score.title];
                [weakSelf.scoreData addObject:score.score];
                if ([score.title isEqualToString:@"情绪"]) {
                    [weakSelf.radarData replaceObjectAtIndex:0 withObject:score.score];
                } else if ([score.title isEqualToString:@"睡眠"]) {
                    [weakSelf.radarData replaceObjectAtIndex:1 withObject:score.score];
                } else if ([score.title isEqualToString:@"焦虑"]) {
                    [weakSelf.radarData replaceObjectAtIndex:2 withObject:score.score];
                } else if ([score.title isEqualToString:@"疼痛"]) {
                    [weakSelf.radarData replaceObjectAtIndex:3 withObject:score.score];
                }else if ([score.title isEqualToString:@"性功能"]) {
                    [weakSelf.radarData replaceObjectAtIndex:4 withObject:score.score];
                }else if ([score.title isEqualToString:@"满意度"]) {
                    [weakSelf.radarData replaceObjectAtIndex:5 withObject:score.score];
                }else if ([score.title isEqualToString:@"疑病"]) {
                    [weakSelf.radarData replaceObjectAtIndex:6 withObject:score.score];
                }else if ([score.title isEqualToString:@"社交"]) {
                    [weakSelf.radarData replaceObjectAtIndex:7 withObject:score.score];
                }
                
            }
            weakSelf.totalScore = [NSString stringWithFormat:@"%@",[response objectForKey:@"codeText"]];
          
            [_kEchartView setOption:[weakSelf standardRadarOption]];
            [_kEchartView loadEcharts];
            if (weakSelf.scoreTitleData.count>=4) {
                weakSelf.tipLabel1.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[0]];
                weakSelf.tipLabel1Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[0]];
                
                weakSelf.tipLabel2.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[1]];
                weakSelf.tipLabel2Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[1]];
                
                weakSelf.tipLabel3.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[2]];
                weakSelf.tipLabel3Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[2]];
                
                weakSelf.tipLabel4.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[3]];
                weakSelf.tipLabel4Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[3]];
                
                weakSelf.tipLabel1Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[0]];
                weakSelf.tipLabel2Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[1]];
                weakSelf.tipLabel3Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[2]];
                weakSelf.tipLabel4Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[3]];
                
            }
            
        } else {
            
            //                    [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        ZPLog(@"%@",error.localizedDescription);
    } className:[UHViewController class]];
}

//设置不同分数的颜色
- (UIColor *)colorWithScore:(NSString *)score {
    float s = [score floatValue];
    if (s>2 && s<=3) {
        return RGB(255, 0, 0);
    } else if (s>1 && s<=2) {
        return RGB(255, 210, 0);
    }
    return RGB(51, 203, 111);
}

//获取热门资讯
- (void)getHotHealthInformation {
    
    __weak typeof(self) weakSelf = self;
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthInformation/list" parameters:@{@"label":@"",@"position":@"HOMEPAGE"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            
            weakSelf.newsDatas = [UHHealthNewsModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        ZPLog(@"获取热门资讯:%@",error);
        
    } className:[UHViewController class]];
}

//退出登录
- (void)logout {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
    UHLoginController *loginControl = [[UHLoginController alloc] init];
    UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

//清除登录信息
- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
}

//展示雷达图全部数据
- (void)showAllScore {
    if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        //未登录的状态
        UHLoginController *loginControl = [[UHLoginController alloc] init];
        UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    } else {
        //登录后
        WEAK_SELF(weakSelf);
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"get/scores" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [weakSelf.scoreTitleData removeAllObjects];
                [weakSelf.scoreData removeAllObjects];
                NSArray *arrays = [UHGetScore mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                weakSelf.scoreShowDatas = arrays;
                
                
                for (UHGetScore *score in arrays) {
                    [weakSelf.scoreTitleData addObject:score.title];
                    [weakSelf.scoreData addObject:score.score];
                    if ([score.title isEqualToString:@"情绪"]) {
                        [weakSelf.radarData replaceObjectAtIndex:0 withObject:score.score];
                    } else if ([score.title isEqualToString:@"睡眠"]) {
                        [weakSelf.radarData replaceObjectAtIndex:1 withObject:score.score];
                    } else if ([score.title isEqualToString:@"焦虑"]) {
                        [weakSelf.radarData replaceObjectAtIndex:2 withObject:score.score];
                    } else if ([score.title isEqualToString:@"疼痛"]) {
                        [weakSelf.radarData replaceObjectAtIndex:3 withObject:score.score];
                    }else if ([score.title isEqualToString:@"性功能"]) {
                        [weakSelf.radarData replaceObjectAtIndex:4 withObject:score.score];
                    }else if ([score.title isEqualToString:@"满意度"]) {
                        [weakSelf.radarData replaceObjectAtIndex:5 withObject:score.score];
                    }else if ([score.title isEqualToString:@"疑病"]) {
                        [weakSelf.radarData replaceObjectAtIndex:6 withObject:score.score];
                    }else if ([score.title isEqualToString:@"社交"]) {
                        [weakSelf.radarData replaceObjectAtIndex:7 withObject:score.score];
                    }
                }
                weakSelf.totalScore = [NSString stringWithFormat:@"%@",[response objectForKey:@"codeText"]];
                [weakSelf popScore];
                [_kEchartView setOption:[weakSelf standardRadarOption]];
                [_kEchartView loadEcharts];
                if (weakSelf.scoreTitleData.count>=4) {
                    
                    weakSelf.tipLabel1.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[0]];
                    weakSelf.tipLabel1Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[0]];
                    
                    weakSelf.tipLabel2.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[1]];
                    weakSelf.tipLabel2Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[1]];
                    
                    weakSelf.tipLabel3.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[2]];
                    weakSelf.tipLabel3Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[2]];
                    
                    weakSelf.tipLabel4.text = [NSString stringWithFormat:@"%@:",weakSelf.scoreTitleData[3]];
                    weakSelf.tipLabel4Value.text = [NSString stringWithFormat:@"%@分",weakSelf.scoreData[3]];
                    
                    weakSelf.tipLabel1Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[0]];
                    weakSelf.tipLabel2Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[1]];
                    weakSelf.tipLabel3Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[2]];
                    weakSelf.tipLabel4Value.textColor = [weakSelf colorWithScore:weakSelf.scoreData[3]];
                    
                }
                
            } else if ([[response objectForKey:@"code"] integerValue]  == 2209){
                [LEEAlert alert].config
                .LeeContent(@"检测到您还未做过身心评估,\n快去首页-身心管理测试吧")
                .LeeAction(@"我知道了", ^{
                })
                .LeeClickBackgroundClose(YES)
                .LeeShow();
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            ZPLog(@"%@",error.localizedDescription);
            
        } className:[UHViewController class]];
    }
}

//所有的分数的弹窗
- (void)popScore {
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IS_IPHONE5?280:ZPWidth(280), 435)];
    
    //435
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, IS_IPHONE5?276:ZPWidth(276), 435)];
    iconView.image = [UIImage imageNamed:@"score_pop_icon"];
    [temp addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 92, 160,16)];
    titleLabel.textColor =RGB(22,196,100);
    titleLabel.text = @"北京协和医院健康评估";
    titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [iconView addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(iconView);
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, 115, 13)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [NSString stringWithFormat:@"总分 %@",self.totalScore];
    nameLabel.font = [UIFont fontWithName:ZPPFSCMedium size:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [iconView addSubview:nameLabel];
    nameLabel.sd_layout.centerXEqualToView(iconView);
    
    //208 184
    UHRadarPopTableView *tableView = [[UHRadarPopTableView alloc] initWithFrame:CGRectMake(0, 175, 235, 208) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.array = self.scoreShowDatas;
    [iconView addSubview:tableView];
    tableView.sd_layout
    .centerXEqualToView(iconView);
    
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
    [closeBtn setImage:[UIImage imageNamed:@"close_pop_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    
    [LEEAlert alert].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = temp;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = closeBtn;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(20, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeBackGroundColor([UIColor clearColor])
    .LeeHeaderColor([UIColor clearColor])
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            animatingBlock(); //调用动画中Block
            
        } completion:^(BOOL finished) {
            
            animatedBlock(); //调用动画结束Block
        }];
        
    })
    .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            animatingBlock();
            
        } completion:^(BOOL finished) {
            
            animatedBlock();
        }];
        
    })
    .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type) {
        if (IS_IPHONE5) {
            return 280;
        }
        return ZPWidth(280);
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

//关闭分数的弹窗
- (void)closePop {
   [LEEAlert closeWithCompletionBlock:nil];
}

//企业入门的点击方法
- (void)companyEntanceAction:(UIButton *)btn {
    if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        UHLoginController *loginControl = [[UHLoginController alloc] init];
        UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    } else {
        if ([btn.titleLabel.text isEqualToString:@"企业入口"]) {
            UHBindingCompanyController *companyControl = [[UHBindingCompanyController alloc] init];
            companyControl.updateComBlock = ^{
                
            };
            [self.navigationController pushViewController:companyControl animated:YES];
        }
    }
}

//跳转->更多频道
- (void)moreAuthorityChannel {
    UHAuthorityChannelController *authorityChannelControl = [[UHAuthorityChannelController alloc] init];
    [self.navigationController pushViewController:authorityChannelControl animated:YES];
}

//跳转->更多资讯
- (void)moreHealthNews {
    UHHealthNewsMainController *healthNewsMainControl = [[UHHealthNewsMainController alloc] init];
    [self.navigationController pushViewController:healthNewsMainControl animated:YES];
}

//跳转->热门资讯的详情web页
- (void)hotNewDetail {
    UHHealthNewsWebViewController *webView = [[UHHealthNewsWebViewController alloc] init];
    webView.mainBody = self.mainBody;
    webView.healthNewsModel = self.healthNewsModel;
    [self.navigationController pushViewController:webView animated:YES];
}

//跳转->消息列表
- (void)chatInfoList {
    SessionListViewController *chatList = [[SessionListViewController alloc] init];
    [self.navigationController pushViewController:chatList animated:YES];
}

//跳转->身心管理
- (void)chronicDiseaseManageAction {
    UHPhysicalManageController *physicalManControl = [[UHPhysicalManageController alloc] init];
    [self.navigationController pushViewController:physicalManControl animated:YES];
}

//跳转->个人保障
- (void)myGuarantee {
    //    UHMyGuaranteeController *guaranteeControl = [[UHMyGuaranteeController alloc] init];
    //    [self.navigationController pushViewController:guaranteeControl animated:YES];
    
    [LEEAlert alert].config
    .LeeTitle(@"提醒")
    .LeeContent(@"此模块正在开发中，敬请期待")
    .LeeAction(@"确认", ^{
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

//跳转->各个模块
- (void)didClickEvent:(UIButton *)button {
    switch (button.tag) {
        case 10000:
        {
            //健康自测
            if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                UHLoginController *loginControl = [[UHLoginController alloc] init];
                UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            } else {
                //                UHHealthTestController *testControl = [[UHHealthTestController alloc] init];
                //                [self.navigationController pushViewController:testControl animated:YES];
                UHHealthTestWebViewController *testControl = [[UHHealthTestWebViewController alloc] init];
                [self.navigationController pushViewController:testControl animated:YES];
                
            }
        }
            break;
        case 10001:
        {
            //疾病自查
            [MBProgressHUD showMessage:@"加载中..."];
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"selftest" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    NSBundle *bundle = [NSBundle bundleForClass:[DiseaseMatchViewController class]];
                    DiseaseMatchViewController *vc = [[DiseaseMatchViewController alloc] initWithNibName:@"DiseaseMatchViewController" bundle:bundle];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHViewController class]];
        }
            break;
        case 10002:
        {
            //身心咨询
            UHConsultController *consultControl = [[UHConsultController alloc] init];
            [self.navigationController pushViewController:consultControl animated:YES];
            //            UHConsultDoctorController *doctorControl = [[UHConsultDoctorController alloc] init];
            //            [self.navigationController pushViewController:doctorControl animated:YES];
        }
            break;
        case 10003:
        {
            //绿色通道
            UHReservationServiceController *reservationControl = [[UHReservationServiceController alloc] init];
            [self.navigationController pushViewController:reservationControl animated:YES];
        }
            break;
        default:
        {
            //健康风向
            UHHealthWindController *healthwindControl = [[UHHealthWindController alloc] init];
            [self.navigationController pushViewController:healthwindControl animated:YES];
        }
            break;
    }
    
}


- (UIView *)hotNewView {
    if (!_hotNewView) {
        _hotNewView = [UIView new];
        _hotNewView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotNewDetail)];
        [_hotNewView addGestureRecognizer:tapGesture];
    }
    return _hotNewView;
}

- (NSMutableArray *)scoreData {
    if (!_scoreData) {
        _scoreData = [NSMutableArray array];
    }
    return _scoreData;
}

- (NSMutableArray *)scoreTitleData {
    if (!_scoreTitleData) {
        _scoreTitleData = [NSMutableArray array];
    }
    return _scoreTitleData;
}

- (NSMutableArray *)radarData {
    if (!_radarData) {
        _radarData = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0,nil];
    }
    return _radarData;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(244, 244, 244);
    }
    return _lineView;
}

- (UIView *)authoritylineView {
    if (!_authoritylineView) {
        _authoritylineView = [UIView new];
        _authoritylineView.backgroundColor = RGB(244, 244, 244);
    }
    return _authoritylineView;
}

- (NSArray *)scoreShowDatas {
    if (!_scoreShowDatas) {
        _scoreShowDatas = [NSArray array];
    }
    return _scoreShowDatas;
}

- (UILabel *)tipLabel1Value {
    if (!_tipLabel1Value) {
        _tipLabel1Value = [UILabel new];
        _tipLabel1Value.text = @"0分";
        _tipLabel1Value.textColor = RGB(51,203,111);
        _tipLabel1Value.textAlignment = NSTextAlignmentRight;
        _tipLabel1Value.font = [UIFont fontWithName:ZPPFSCLight size:13];
    }
    return _tipLabel1Value;
}

- (UILabel *)tipLabel2Value {
    if (!_tipLabel2Value) {
        _tipLabel2Value = [UILabel new];
        _tipLabel2Value.text = @"0分";
        _tipLabel2Value.textColor = RGB(255,210,0);
        _tipLabel2Value.textAlignment = NSTextAlignmentRight;
        _tipLabel2Value.font = [UIFont fontWithName:ZPPFSCLight size:13];
    }
    return _tipLabel2Value;
}

- (UILabel *)tipLabel3Value {
    if (!_tipLabel3Value) {
        _tipLabel3Value = [UILabel new];
        _tipLabel3Value.text = @"0分";
        _tipLabel3Value.textColor = RGB(255,120,0);
        _tipLabel3Value.textAlignment = NSTextAlignmentRight;
        _tipLabel3Value.font = [UIFont fontWithName:ZPPFSCLight size:13];
    }
    return _tipLabel3Value;
}

- (UILabel *)tipLabel4Value {
    if (!_tipLabel4Value) {
        _tipLabel4Value = [UILabel new];
        _tipLabel4Value.text = @"0分";
        _tipLabel4Value.textColor = RGB(255,0,0);
        _tipLabel4Value.textAlignment = NSTextAlignmentRight;
        _tipLabel4Value.font = [UIFont fontWithName:ZPPFSCLight size:13];
        _tipLabel4Value.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllScore)];
        [_tipLabel4Value addGestureRecognizer:tap];
    }
    return _tipLabel4Value;
}

- (UIButton *)moreScoreButton {
    if (!_moreScoreButton) {
        _moreScoreButton = [UIButton new];
        [_moreScoreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreScoreButton setTitleColor:RGB(78,178,255) forState:UIControlStateNormal];
        _moreScoreButton.titleLabel.font = [UIFont fontWithName:ZPPFSCLight size:13];
        [_moreScoreButton addTarget:self action:@selector(showAllScore) forControlEvents:UIControlEventTouchUpInside];
        [_moreScoreButton setImage:[UIImage imageNamed:@"more_arrowBlue_icon"] forState:UIControlStateNormal];
    }
    return _moreScoreButton;
}

- (NSArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSArray array];
    }
    return _bannerArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHHealthNewsMoreImagesCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthNewsMoreImagesCell class])];
        [_tableView registerClass:[UHHealthNewsOneImageCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthNewsOneImageCell class])];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸(行距,列距)
        layout.minimumLineSpacing = 13;
        layout.minimumInteritemSpacing = 20;
        // 设置cell的宽度
        layout.itemSize = CGSizeMake(200, 100);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.headerReferenceSize = CGSizeMake(13, 100);
        layout.footerReferenceSize = CGSizeMake(13, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UHAuthorityChannelCell class] forCellWithReuseIdentifier:NSStringFromClass([UHAuthorityChannelCell class])];
    }
    return _collectionView;
}

- (NSArray *)channelDatas {
    if (!_channelDatas) {
        _channelDatas = [NSArray array];
    }
    return _channelDatas;
}

- (UIView *)tempgrayView {
    if (!_tempgrayView) {
        _tempgrayView = [UIView new];
        _tempgrayView.backgroundColor = RGB(242, 242, 242);
    }
    return _tempgrayView;
}
@end
