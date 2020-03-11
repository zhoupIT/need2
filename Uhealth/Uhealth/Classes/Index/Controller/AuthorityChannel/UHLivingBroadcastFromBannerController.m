//
//  UHLivingBroadcastFromBannerController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHLivingBroadcastFromBannerController.h"
#import "UHLectureModel.h"
#import "UHLivingBroadcastTopCell.h"
#import "UHChannelDoctorModel.h"
#import "UHLivingBroadcastCell.h"
#import "UHAllLectureHistoryCell.h"
#import "UHMoreLecturesController.h"
#import "UHLectureWebController.h"
#import "DateTools.h"
#import "UHLoginController.h"
#import "UHNavigationController.h"

#import "XBTimerManager.h"
@interface UHLivingBroadcastFromBannerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UHLectureModel *topLectureModel;
@property (nonatomic,strong) NSMutableArray *histroyData;
@property (nonatomic,strong) NSMutableArray *allData;

@property (nonatomic,strong) UIButton *enterBtn;
@property (nonatomic,strong) NSMutableArray *twoArray;
@property (nonatomic,strong) dispatch_source_t timer;
@end

@implementation UHLivingBroadcastFromBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self getData];
}

- (void)initAll {
    self.view.backgroundColor = KControlColor;
    self.title = @"直播名称";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.view addSubview:self.enterBtn];
    self.enterBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50);
    
    
    self.tableView.backgroundColor = KControlColor;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_lecture_icon"
                                                            titleStr:@""
                                                           detailStr:@""];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}

- (void)backAction {
    //    self.closeTime = YES;
    [[XBTimerManager sharedXBTimerManager] stopGcdTimer];
    //    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setButtonAttribute:(UIButton *)btn {
//    NSString *lectureDate = self.topLectureModel.lectureDate;
//    NSDate *lectureDateTime = [NSDate dateWithString:lectureDate formatString:@"yyyy-MM-dd HH:mm"];
//    BOOL canLecture = [[NSDate date] isLaterThanOrEqualTo:lectureDateTime];
//    if (canLecture) {
//        //进入讲堂
//        [self.enterBtn setTitle:@"进入讲堂" forState:UIControlStateNormal];
//    } else {
//        NSString *t0 = self.topLectureModel.hasSubscribed?@"已预约\n":@"立即预约\n";
//        NSString *t1 = [NSString stringWithFormat:@"(开放时间:%@)",self.topLectureModel.lectureDate];
//        NSDictionary *attrTitleDict0 = @{NSFontAttributeName: [UIFont fontWithName:ZPPFSCRegular size:16],NSForegroundColorAttributeName: RGB(255, 255, 255)};
//        NSDictionary *attrTitleDict1 = @{NSFontAttributeName: [UIFont fontWithName:ZPPFSCRegular size:12],NSForegroundColorAttributeName: RGB(255,254,254)};
//
//        NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString: [t0 substringWithRange: NSMakeRange(0, t0.length)] attributes: attrTitleDict0];
//        NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [t1 substringWithRange: NSMakeRange(0, t1.length)] attributes: attrTitleDict1];
//
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr0];
//        [attributedStr appendAttributedString:attrStr1];
//        [self.enterBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
//
//        __weak __typeof(self) weakSelf = self;
//
//        if (_timer == nil) {
//            __block NSInteger timeout = [[NSDate date] secondsEarlierThan:lectureDateTime]; // 倒计时时间
//
//            if (timeout!=0) {
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//                dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
//                dispatch_source_set_event_handler(_timer, ^{
//                    if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
//                        dispatch_source_cancel(_timer);
//                        _timer = nil;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            ZPLog(@"您可以进入讲堂了");
//                            NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"进入讲堂"];
//                            [weakSelf.enterBtn setAttributedTitle:string forState:UIControlStateNormal];
//                        });
//                    } else {
//                        ZPLog(@"当前讲座您还需要等待的时间:%ld",timeout);
//                        timeout--; // 递减 倒计时-1(总时间以秒来计算)
//                    }
//                });
//                dispatch_resume(_timer);
//            }
//        }
//    }
    
    NSString *lectureDate = self.topLectureModel.lectureDate;
    NSDate *lectureDateTime = [NSDate dateWithString:lectureDate formatString:@"yyyy-MM-dd HH:mm"];
    BOOL canLecture = [[NSDate date] isLaterThanOrEqualTo:lectureDateTime];
    if (canLecture) {
        //进入讲堂
        self.topLectureModel.timeout = 0;
        [self.tableView reloadData];
    } else {
        __block NSInteger timeout = [[NSDate date] secondsEarlierThan:lectureDateTime]; // 倒计时时间
        
        if (timeout!=0) {
            self.topLectureModel.timeout = timeout;
            [self.tableView reloadData];
        }
    }
}

- (void)getData {
    WEAK_SELF(weakSelf);
    if (self.ID && self.ID.length) {
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"api/advisory/channel/doctor/lecture/detail/%@",self.ID] parameters:nil progress:^(NSProgress *progress) {

        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPLog(@"%@",response);
                weakSelf.topLectureModel = [UHLectureModel mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"detail"]];
                weakSelf.title = weakSelf.topLectureModel.lectureName;
                [weakSelf setButtonAttribute:weakSelf.enterBtn];
                if (weakSelf.topLectureModel.ID.length== 0) {
                    weakSelf.enterBtn.hidden = YES;
                }
                weakSelf.topLectureModel.isBannerEnter = YES;
                [weakSelf.tableView reloadData];
            } else {

                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
             [MBProgressHUD showError:error.localizedDescription];
        } className:[UHLivingBroadcastFromBannerController class]];
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
    
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
        UHLivingBroadcastTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHLivingBroadcastTopCell class])];
        self.topLectureModel.isBannerEnter = YES;
        cell.model = self.topLectureModel;
        cell.enterLectureBlock = ^{
            [weakSelf enterLectureAction];
        };
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
        return [tableView cellHeightForIndexPath:indexPath model:self.topLectureModel keyPath:@"model" cellClass:[UHLivingBroadcastTopCell class] contentViewWidth:SCREEN_WIDTH];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - private
- (void)enterLectureAction {
//    NSString *btnStr = self.enterBtn.titleLabel.text;
//    if ([btnStr isEqualToString:@"进入讲堂"]) {
        if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
            [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
                
            } failed:^(NSError *error) {
                
            }];
            NSString *token = [kUSER_DEFAULT objectForKey:@"lectureToken"];
            NSString *baseString = [Utils base64StringFromText:token];
            UHLectureWebController *webControl = [[UHLectureWebController alloc] init];
            webControl.titleString = self.topLectureModel.lectureName;
            webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@&token=%@",ZPBaseUrl,self.topLectureModel.roomid,baseString];
            ZPLog(@"聊天室的地址:%@",webControl.url);
            [self.navigationController pushViewController:webControl animated:YES];
        } else {
            [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
                
            } failed:^(NSError *error) {
                
            }];
            UHLectureWebController *webControl = [[UHLectureWebController alloc] init];
            webControl.titleString = self.topLectureModel.lectureName;
            webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@",ZPBaseUrl,self.topLectureModel.roomid];
            [self.navigationController pushViewController:webControl animated:YES];
        }
//    }
}

- (void)enterAction {
    /*
    NSString *btnStr = self.enterBtn.titleLabel.text;
    if ([btnStr containsString:@"预约"]) {
        if (![btnStr containsString:@"已预约"]) {
            WEAK_SELF(weakSelf);
            [[ZPNetWork sharedZPNetWork] requestWithUrl:[NSString stringWithFormat:@"/api/advisory/channel/doctor/lecture/subscribe/%@",self.topLectureModel.ID] andHTTPMethod:@"PUT" andDict:nil success:^(NSDictionary *response) {
                weakSelf.topLectureModel.hasSubscribed = YES;
                NSString *t0 = @"已预约\n";
                NSString *t1 = [NSString stringWithFormat:@"(开放时间:%@)",weakSelf.topLectureModel.lectureDate];
                NSDictionary *attrTitleDict0 = @{NSFontAttributeName: [UIFont fontWithName:ZPPFSCRegular size:16],NSForegroundColorAttributeName: RGB(255, 255, 255)};
                NSDictionary *attrTitleDict1 = @{NSFontAttributeName: [UIFont fontWithName:ZPPFSCRegular size:12],NSForegroundColorAttributeName: RGB(255,254,254)};
                
                NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString: [t0 substringWithRange: NSMakeRange(0, t0.length)] attributes: attrTitleDict0];
                NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [t1 substringWithRange: NSMakeRange(0, t1.length)] attributes: attrTitleDict1];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr0];
                [attributedStr appendAttributedString:attrStr1];
                if (![weakSelf.enterBtn.titleLabel.text containsString:@"进入讲堂"]) {
                    [weakSelf.enterBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
                }
                
                
                [LEEAlert alert].config
                .LeeTitle(@"已预约")
                .LeeContent(@"讲堂开始前我们会短信通知您,注意查看短信,千万不要错过哦~")
                .LeeAction(@"确认", ^{
                })
                .LeeClickBackgroundClose(YES)
                .LeeShow();
                
            } failed:^(NSError *error) {
                
            }];
            
        }
    } else {
     */
        if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
            [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
                
            } failed:^(NSError *error) {
                
            }];
            NSString *token = [kUSER_DEFAULT objectForKey:@"lectureToken"];
            NSString *baseString = [Utils base64StringFromText:token];
            UHLectureWebController *webControl = [[UHLectureWebController alloc] init];
            webControl.titleString = self.topLectureModel.lectureName;
            webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@&token=%@",ZPBaseUrl,self.topLectureModel.roomid,baseString];
            ZPLog(@"聊天室的地址:%@",webControl.url);
            [self.navigationController pushViewController:webControl animated:YES];
        } else {
            [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/advisory/lecture/log" andHTTPMethod:@"PUT" andDict:@{@"lectureId":self.topLectureModel.ID} success:^(NSDictionary *response) {
                
            } failed:^(NSError *error) {
                
            }];
            UHLectureWebController *webControl = [[UHLectureWebController alloc] init];
            webControl.titleString = self.topLectureModel.lectureName;
            webControl.url = [NSString stringWithFormat:@"%@/chatroom?roomId=%@",ZPBaseUrl,self.topLectureModel.roomid];
            [self.navigationController pushViewController:webControl animated:YES];
        }
//    }
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSMutableArray *)histroyData {
    if (!_histroyData) {
        _histroyData = [NSMutableArray array];
    }
    return _histroyData;
}

- (NSMutableArray *)allData {
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHLivingBroadcastTopCell class] forCellReuseIdentifier:NSStringFromClass([UHLivingBroadcastTopCell class])];
        [_tableView registerClass:[UHLivingBroadcastCell class] forCellReuseIdentifier:NSStringFromClass([UHLivingBroadcastCell class])];
        [_tableView registerClass:[UHAllLectureHistoryCell class] forCellReuseIdentifier:NSStringFromClass([UHAllLectureHistoryCell class])];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZPHeight(60))];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"lecture_foot_icon"];
        [view addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(view)
        .heightIs(ZPHeight(23*0.5))
        .widthIs(ZPWidth(637*0.5))
        .centerXEqualToView(view);
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton new];
        [_enterBtn setTitle:@"进入讲堂" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn setBackgroundColor:ZPMyOrderDetailValueFontColor];
        _enterBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:16];
        _enterBtn.titleLabel.numberOfLines = 2;
        _enterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (NSMutableArray *)twoArray {
    if (!_twoArray) {
        _twoArray = [NSMutableArray array];
        [_twoArray addObject:@1];
        [_twoArray addObject:@1];
    }
    return _twoArray;
}

- (UHLectureModel *)topLectureModel {
    if (!_topLectureModel) {
        _topLectureModel = [[UHLectureModel alloc] init];
        _topLectureModel.isBannerEnter = YES;
        _topLectureModel.lectureSpeaker = @"";
        _topLectureModel.lectureDoctorIntroduction = @"";
        _topLectureModel.lectureIntroduction = @"";
    }
    return _topLectureModel;
}
@end
