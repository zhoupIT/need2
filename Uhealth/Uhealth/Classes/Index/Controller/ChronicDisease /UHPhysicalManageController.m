//
//  UHPhysicalManageController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPhysicalManageController.h"
#import "UHUserModel.h"
#import "UHChronicDiseaseManageMentController.h"
#import "UHMentalManageController.h"
#import "UHPsychologicalAssessmentController.h"
#import "UHPsyAssessmentModel.h"
#import "UHPsychologicalAssessController.h"
#import "UHPhysicalManageCell.h"
@interface UHPhysicalManageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation UHPhysicalManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身心管理";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = KControlColor;
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHPhysicalManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHPhysicalManageCell class])];
    cell.dict = self.data[indexPath.section];
    WEAK_SELF(weakSelf);
    cell.startBlock = ^{
        if (indexPath.section == 0) {
            [MBProgressHUD showMessage:@"加载中..."];
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"psychologicalAssessment/register" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    UHPsyAssessmentModel *psyModel = [UHPsyAssessmentModel mj_objectWithKeyValues:[response objectForKey:@"data"] ];
                    if (psyModel.infoFilled) {
                        //信息已填
                        UHMentalManageController *mentalManageControl = [[UHMentalManageController alloc] init];
                        mentalManageControl.titleStr = @"身心健康评估";
                        mentalManageControl.urlStr = psyModel.ticketEntry;
                        mentalManageControl.infoFilled = YES;
                        [weakSelf.navigationController pushViewController:mentalManageControl animated:YES];
                    } else {
                        UHPsychologicalAssessmentController *psyControl = [[UHPsychologicalAssessmentController alloc] init];
                        psyControl.psyModel = psyModel;
                        [weakSelf.navigationController pushViewController:psyControl animated:YES];
                    }
                } else {
                    
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHPhysicalManageController class]];
            
        } else {
            UHChronicDiseaseManageMentController *managementContr = [[UHChronicDiseaseManageMentController alloc] init];
#warning 这边暂时不开放企业用户的功能,注释掉
            /*
             if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
             UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
             if (![model.companyName isEqualToString:@""]) {
             managementContr.isCompany = YES;
             }
             }
             */
            [weakSelf.navigationController pushViewController:managementContr animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZPHeight(135);
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 11.f;
    }
    return 7.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSArray *)data {
    if (!_data) {
        _data =@[@{@"iconName":@"physicalManage_bjxh_icon",@"tip1Name":@"北京协和医院",@"tip2Name":@"身心评估",@"buttonName":@"开始评估>>"},@{@"iconName":@"physicalManage_icon",@"tip1Name":@"健康数据 慢病管理",@"tip2Name":@"实时监控",@"buttonName":@"点击查看>>"}];
    }
    return _data;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[UHPhysicalManageCell class] forCellReuseIdentifier:NSStringFromClass([UHPhysicalManageCell class])];
    }
    return _tableView;
}

@end
