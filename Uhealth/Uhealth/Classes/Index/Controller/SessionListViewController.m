//
//  SessionListViewController.m
//  uhealth
//
//  Created by Biao Geng on 2018/3/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SessionListViewController.h"
#import "UIView+NTES.h"
#import "UHNotificationController.h"
#import "WZLBadgeImport.h"
#import "UHNotiModel.h"
@interface SessionListViewController ()
@property (nonatomic,strong)NSMutableDictionary* dataInfo;
@property(nonatomic,assign)int currentPage;
@property (nonatomic,copy) NSString *message;
@end

@implementation SessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setup];
    // Do any additional setup after loading the view.
    self.title = @"通知";
  
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHead)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    self.tableView.tableFooterView = [UIView new];
    self.currentPage = 1;
    
    self.tableView.backgroundColor = KControlColor;
    
    [self getData];
}

- (void)getData {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/message" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSArray *data = [UHNotiModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            if (data.count) {
                UHNotiModel *model = data.firstObject;
                weakSelf.message = model.content;
                [weakSelf.tableView reloadData];
            }
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[SessionListViewController class]];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //获取聊天列表中的人物信息
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshHead{
    self.currentPage = 1;
    self.dataInfo = nil;
    [self downloadData];
    [self.tableView.mj_header endRefreshing];
}
-(void)refreshFooter{
    self.currentPage ++;
    [self downloadData];
    
    [self.tableView.mj_footer endRefreshing];
    
}
//获取系统消息等
- (void)downloadData{
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD show];
//
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//    [dict setObject:[DataStore sharedDataStore].token forKey:@"token"];
//
//    [[NetWorkEngine shareNetWorkEngine] postInfoFromServerWithUrlStr:[NSString stringWithFormat:@"%@Message/mymessage.html",HttpURLString] Paremeters:dict successOperation:^(id object) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD setDefaultMaskType:1];
//        if (isKindOfNSDictionary(object)){
//            NSInteger code = [object[@"errcode"] integerValue];
//            NSString *msg = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]] ;
//            NSLog(@"输出 %@--%@",object,msg);
//
//            if (code == 1) {
//                self.dataInfo = [NSMutableDictionary dictionaryWithDictionary:object[@"data"]];
//
//                [self.tableView reloadData];
//            }else{
//                //                [SVProgressHUD showErrorWithStatus:msg];
//            }
//        }
//
//    } failoperation:^(NSError *error) {
//
//        [SVProgressHUD dismiss];
//        [SVProgressHUD setDefaultMaskType:1];
//        [SVProgressHUD showErrorWithStatus:@"网络信号差，请稍后再试"];
//    }];
}
//通知触发方法
- (void)pushMineView:(NSNotification *)notification{
    [self.tabBarController setSelectedIndex:3];
}
- (void)refreshMessage:(NSNotification *)notification{
    [self downloadData];
}


//跳转系统通知页面
- (void) messagePush:(UIButton*)sender{
    UHNotificationController *notiControl = [[UHNotificationController alloc] init];
    [self.navigationController pushViewController:notiControl animated:YES];
}

#pragma mark - tableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        v.backgroundColor = KControlColor;
        
        NSArray* imgAry = @[@"index_systemNoti_icon"];
        NSArray* titleAry = @[@"系统通知"];
        if (self.message == nil || [self.message isKindOfClass:[NSNull class]]) {
            self.message = @"";
        }
        NSMutableArray* subAry = [NSMutableArray arrayWithObjects:self.message,@"",@"", nil];
        
        //布置信息
       

            UIButton *cell = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 80)];
            [v addSubview:cell];
            cell.backgroundColor = [UIColor whiteColor];
            cell.tag = 0;
            [cell addTarget:self action:@selector(messagePush:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 55, 55)];
            img.image = [UIImage imageNamed:imgAry[0]];
            [cell addSubview:img];
//            [img showNumberBadgeWithValue:2];
        
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
            [cell addSubview:titleLab];
            titleLab.text = titleAry[0];
            titleLab.textColor = ZPMyOrderDetailFontColor;
            titleLab.font = [UIFont systemFontOfSize:15];
            [titleLab sizeToFit];
        
            UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
            subTitleLab.text = subAry[0];
            subTitleLab.textColor = ZPMyOrderDeleteBorderColor;
            subTitleLab.font = [UIFont systemFontOfSize:14];
            [cell addSubview:subTitleLab];
            [subTitleLab sizeToFit];
         
            UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
            timeLab.text = @"";
            timeLab.textColor = [UIColor lightGrayColor];
            [cell addSubview:timeLab];
            [timeLab sizeToFit];
           
            titleLab.sd_layout
            .leftSpaceToView(img, 15)
            .topSpaceToView(cell, 22)
            .heightIs(15)
            .widthIs(100);
            
            subTitleLab.sd_layout
            .topSpaceToView(titleLab, 12)
            .leftEqualToView(titleLab)
            .heightIs(14)
            .rightSpaceToView(cell, 10);
            
            timeLab.sd_layout
            .rightSpaceToView(cell, 10)
            .topEqualToView(img)
            .heightIs(15)
            .widthIs(100);
        return v;
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

////云信跳转聊天页面
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
//    [self onSelectedRecent:recentSession atIndexPath:indexPath];
//}
//- (void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath{
////    ChatViewController *vc = [[ChatViewController alloc] initWithSession:recentSession.session];
////    [self.navigationController pushViewController:vc animated:YES];
//}
@end
