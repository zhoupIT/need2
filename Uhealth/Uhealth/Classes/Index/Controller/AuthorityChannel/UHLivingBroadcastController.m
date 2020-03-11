//
//  UHLivingBroadcastController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHLivingBroadcastController.h"
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
#import "UHTabBarViewController.h"
#import "XBTimerManager.h"
#import "UHHomeViewController.h"
@interface UHLivingBroadcastController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UHLectureModel *topLectureModel;
@property (nonatomic,strong) NSMutableArray *histroyData;
@property (nonatomic,strong) NSMutableArray *allData;

@property (nonatomic,strong) UIButton *enterBtn;
@property (nonatomic,strong) NSMutableArray *twoArray;
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) UIView *footView;
@end

@implementation UHLivingBroadcastController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lecture_backHome_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(backHomeAction)];
}

- (void)backAction {
//    self.closeTime = YES;
    [[XBTimerManager sharedXBTimerManager] stopGcdTimer];
//    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backHomeAction {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[UHHomeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)setButtonAttribute {
    NSString *lectureDate = self.topLectureModel.lectureDate;
    NSDate *lectureDateTime = [NSDate dateWithString:lectureDate formatString:@"yyyy-MM-dd HH:mm"];
    BOOL canLecture = [[NSDate date] isLaterThanOrEqualTo:lectureDateTime];
    if (canLecture) {
        //进入讲堂
//        [self.enterBtn setTitle:@"进入讲堂" forState:UIControlStateNormal];
        self.topLectureModel.timeout = 0;
        [self.tableView reloadData];
    } else {
        /*
        NSString *t0 = self.topLectureModel.hasSubscribed?@"已预约\n":@"立即预约\n";
        NSString *t1 = [NSString stringWithFormat:@"(开放时间:%@)",self.topLectureModel.lectureDate];
        NSDictionary *attrTitleDict0 = @{NSFontAttributeName: [UIFont fontWithName:ZPPFSCRegular size:16],NSForegroundColorAttributeName: RGB(255, 255, 255)};
        NSDictionary *attrTitleDict1 = @{NSFontAttributeName: [UIFont fontWithName:ZPPFSCRegular size:12],NSForegroundColorAttributeName: RGB(255,254,254)};
        
        NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString: [t0 substringWithRange: NSMakeRange(0, t0.length)] attributes: attrTitleDict0];
        NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [t1 substringWithRange: NSMakeRange(0, t1.length)] attributes: attrTitleDict1];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr0];
        [attributedStr appendAttributedString:attrStr1];
        [self.enterBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
         */
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
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"lecture/list" parameters:@{@"doctorId":self.doctorId,@"limit":@5,@"id":self.ID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPLog(@"%@",response);
                weakSelf.histroyData = [UHLectureModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"list"]];
                weakSelf.allData =  [UHLectureModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"all"]];
                weakSelf.topLectureModel = [UHLectureModel mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"detail"]];
                weakSelf.title = weakSelf.topLectureModel.lectureName;
                //            [weakSelf.data removeObjectAtIndex:0];
                 [weakSelf setButtonAttribute];
                if (!weakSelf.histroyData.count && !weakSelf.allData.count && weakSelf.topLectureModel.ID.length== 0) {
                    [weakSelf.twoArray removeAllObjects];
                    weakSelf.enterBtn.hidden = YES;
                    weakSelf.tableView.tableFooterView = [UIView new];
                } else {
                    weakSelf.enterBtn.hidden = NO;
                    weakSelf.tableView.tableFooterView = weakSelf.footView;
                }
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.twoArray removeAllObjects];
                weakSelf.enterBtn.hidden = YES;
                weakSelf.tableView.tableFooterView = [UIView new];
                [weakSelf.tableView reloadData];
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.twoArray removeAllObjects];
            weakSelf.enterBtn.hidden = YES;
            weakSelf.tableView.tableFooterView = [UIView new];
            [weakSelf.tableView reloadData];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHLivingBroadcastController class]];
    } else {
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"lecture/list" parameters:@{@"doctorId":self.doctorId,@"limit":@6} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPLog(@"%@",response);
                weakSelf.histroyData = [UHLectureModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"list"]];
                weakSelf.allData =  [UHLectureModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"all"]];
                weakSelf.topLectureModel = [UHLectureModel mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"detail"]];
                weakSelf.title = weakSelf.topLectureModel.lectureName;
                [weakSelf setButtonAttribute];
                if (!weakSelf.histroyData.count && !weakSelf.allData.count && weakSelf.topLectureModel.ID.length== 0) {
                    [weakSelf.twoArray removeAllObjects];
                    weakSelf.enterBtn.hidden = YES;
                    weakSelf.tableView.tableFooterView = [UIView new];
                } else {
                    weakSelf.enterBtn.hidden = NO;
                    weakSelf.tableView.tableFooterView = weakSelf.footView;
                }
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.twoArray removeAllObjects];
                weakSelf.enterBtn.hidden = YES;
                weakSelf.tableView.tableFooterView = [UIView new];
                [weakSelf.tableView reloadData];
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.twoArray removeAllObjects];
            weakSelf.enterBtn.hidden = YES;
            weakSelf.tableView.tableFooterView = [UIView new];
            [weakSelf.tableView reloadData];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHLivingBroadcastController class]];
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
    
    return self.twoArray.count+self.histroyData.count+self.allData.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
    if (indexPath.row == 0) {
        UHLivingBroadcastTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHLivingBroadcastTopCell class])];
        cell.model = self.topLectureModel;
        cell.moreHistoryLecturesBlock = ^{
            //ta的历史讲座
            UHMoreLecturesController *control = [[UHMoreLecturesController alloc] init];
            control.allLecture = NO;
            control.doctorId = weakSelf.doctorId;
            control.toplectureId = weakSelf.topLectureModel.ID;
            [weakSelf.navigationController pushViewController:control animated:YES];
        };
        cell.enterLectureBlock = ^{
            [weakSelf enterLectureAction];
        };
        return cell;
    } else if (indexPath.row <= self.histroyData.count) {
        UHLivingBroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHLivingBroadcastCell class])];
        cell.model = self.histroyData[indexPath.row-1];
        return cell;
    } else if (indexPath.row == (self.histroyData.count+1)) {
        UHAllLectureHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHAllLectureHistoryCell class])];
        cell.moreHistoryLecturesBlock = ^{
          //全部讲座
            UHMoreLecturesController *control = [[UHMoreLecturesController alloc] init];
            control.allLecture = YES;
            control.toplectureId = weakSelf.topLectureModel.ID;
            [weakSelf.navigationController pushViewController:control animated:YES];
        };
        return cell;
    }
    UHLivingBroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHLivingBroadcastCell class])];
    cell.model = self.allData[indexPath.row-2-self.histroyData.count];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
         return [tableView cellHeightForIndexPath:indexPath model:self.topLectureModel keyPath:@"model" cellClass:[UHLivingBroadcastTopCell class] contentViewWidth:SCREEN_WIDTH];
    } else if (indexPath.row <= self.histroyData.count) {
        return [tableView cellHeightForIndexPath:indexPath model:self.histroyData[indexPath.row-1] keyPath:@"model" cellClass:[UHLivingBroadcastCell class] contentViewWidth:SCREEN_WIDTH];
    } else if (indexPath.row == (self.histroyData.count+1)) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
    }
    return [tableView cellHeightForIndexPath:indexPath model:self.allData[indexPath.row-2-self.histroyData.count] keyPath:@"model" cellClass:[UHLivingBroadcastCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0 || indexPath.row == (self.histroyData.count+1) ) {
        
    }  else if (indexPath.row <= self.histroyData.count) {
        //ta的历史讲座
        UHLectureModel *model = self.histroyData[indexPath.row-1];
        UHLivingBroadcastController *livingBroadCastControl = [[UHLivingBroadcastController alloc] init];
        livingBroadCastControl.ID =model.ID;
        livingBroadCastControl.doctorId = model.doctorId;
        [self.navigationController pushViewController:livingBroadCastControl animated:YES];
    } else {
        //全部讲座
        UHLectureModel *model = self.allData[indexPath.row-2-self.histroyData.count];
        UHLivingBroadcastController *livingBroadCastControl = [[UHLivingBroadcastController alloc] init];
        livingBroadCastControl.ID =model.ID;
        livingBroadCastControl.doctorId = model.doctorId;
        [self.navigationController pushViewController:livingBroadCastControl animated:YES];
    }
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
}


//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
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

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZPHeight(60))];
        _footView.backgroundColor = [UIColor clearColor];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"lecture_foot_icon"];
        [_footView addSubview:iconView];
        iconView.sd_layout
        .centerYEqualToView(_footView)
        .heightIs(ZPHeight(23*0.5))
        .widthIs(ZPWidth(637*0.5))
        .centerXEqualToView(_footView);
    }
    return _footView;
}
@end
