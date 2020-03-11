//
//  UHArticleCommentListController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHArticleCommentListController.h"
#import "UHArticleCommentListCell.h"
#import "UHArticleCommentModel.h"
#import "UHHealthWindModel.h"
#import "UHArticleCommentListHeaderView.h"
#import "CLBottomCommentView.h"
#import "PopoverView.h"
#import "UHHealthNewsModel.h"
#import "UHUserModel.h"
typedef NS_ENUM (NSInteger,ZPOrderByType) {
    ZPOrderByTypeTime,
    ZPOrderByTypeLike
};
static CGFloat const kBottomViewHeight = 46.0;
@interface UHArticleCommentListController ()<UITableViewDelegate,UITableViewDataSource,CLBottomCommentViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) UHArticleCommentListHeaderView *headerView;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic, strong) CLBottomCommentView *bottomView;
//排序
@property (nonatomic,assign) ZPOrderByType orderByType;
@end

@implementation UHArticleCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                           titleStr:@"暂无数据"
                                                                          detailStr:@""];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    //从banner跳转来的
//    if (self.enterStatusType == ZPCommentListEnterStatusTypeBanner) {
//        [self getDataFromID:self.bannerAim];
//    }
}

- (void)initAll {
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.view addSubview:self.bottomView];
    [self.bottomView hiddenCommentAndShareView];
    self.headerView = [[UHArticleCommentListHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    if (self.articleType == ZPArticleTypeWind) {
        self.headerView.model = self.windModel;
    } else {
        self.headerView.healthNewsModel = self.healthNewsModel;
    }
    [self.tableView setTableHeaderView:  self.headerView];
    WEAK_SELF(weakSelf);
    //默认排序  热度排序
    self.orderByType = ZPOrderByTypeLike;
    self.headerView.updateHeightBlock = ^(UHArticleCommentListHeaderView *view) {
        if (!weakSelf) return ;
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView setTableHeaderView: view];
        [weakSelf.tableView endUpdates];
    };
    
    self.headerView.popBlock = ^(UIButton *btn) {
      
        
//        [weakSelf.tableView.mj_header beginRefreshing];
        
        PopoverView *popoverView = [PopoverView popoverView];
        if (weakSelf.orderByType == ZPOrderByTypeTime) {
            popoverView.selStr  = @"按时间";
        } else {
             popoverView.selStr  = @"按热度";
        }
        popoverView.showShade = YES; // 显示阴影背景
        popoverView.arrowStyle = PopoverViewArrowStyleTriangle;
        PopoverAction *action1 = [PopoverAction actionWithTitle:@"按热度" handler:^(PopoverAction *action) {
            if (weakSelf.orderByType != ZPOrderByTypeLike) {
                weakSelf.orderByType = ZPOrderByTypeLike;
                [btn setTitle:@"按热度" forState:UIControlStateNormal];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            
        }];
        PopoverAction *action2 = [PopoverAction actionWithTitle:@"按时间" handler:^(PopoverAction *action) {
             if (weakSelf.orderByType != ZPOrderByTypeTime) {
                weakSelf.orderByType = ZPOrderByTypeTime;
                [btn setTitle:@"按时间" forState:UIControlStateNormal];
                [weakSelf.tableView.mj_header beginRefreshing];
             }
        }];
        [popoverView showToView:btn withActions:@[action1,action2]];
        
    };
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString *articleCommentOrderBy = @"COMMENT_TIME_DESC";
        if (weakSelf.orderByType == ZPOrderByTypeTime) {
            articleCommentOrderBy = @"COMMENT_TIME_DESC";
        } else {
             articleCommentOrderBy = @"LIKE_COUNT_DESC";
        }
        
        NSString *articleType = @"HEALTH_DIRECTION";
        NSString *articleId;
        if (weakSelf.articleType == ZPArticleTypeWind) {
            articleType = @"HEALTH_DIRECTION";
            articleId = self.windModel.directionId;
        } else {
            articleType = @"HEALTH_INFORMATION";
            articleId = self.healthNewsModel.informationId;
        }
        
        
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"article/comment" parameters:@{@"articleId":articleId,@"articleType":articleType,@"articleCommentOrderBy":articleCommentOrderBy} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if (weakSelf.articleType == ZPArticleTypeWind) {
                    weakSelf.windModel.toatalCommentsCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
                    weakSelf.headerView.model = weakSelf.windModel;
                } else {
                    weakSelf.healthNewsModel.toatalCommentsCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
                    weakSelf.headerView.healthNewsModel = weakSelf.healthNewsModel;
                }
                self.datas = [UHArticleCommentModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHArticleCommentListController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSString *articleCommentOrderBy = @"COMMENT_TIME_DESC";
        if (weakSelf.orderByType == ZPOrderByTypeTime) {
            articleCommentOrderBy = @"COMMENT_TIME_DESC";
        } else {
            articleCommentOrderBy = @"LIKE_COUNT_DESC";
        }
        NSString *articleType = @"HEALTH_DIRECTION";
        NSString *articleId;
        if (weakSelf.articleType == ZPArticleTypeWind) {
            articleType = @"HEALTH_DIRECTION";
            articleId = self.windModel.directionId;
        } else {
            articleType = @"HEALTH_INFORMATION";
            articleId = self.healthNewsModel.informationId;
        }
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"article/comment" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"articleId":articleId,@"articleType":articleType,@"articleCommentOrderBy":articleCommentOrderBy} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHArticleCommentModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.datas addObjectsFromArray:arrays];
                    [tableView reloadData];
                    
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHArticleCommentListController class]];
    }];
    
}

//通过banner传递来的iD来获取数据
- (void)getDataFromID:(NSString *)ID {
    WEAK_SELF(weakSelf);
    NSString *url = self.articleType == ZPArticleTypeHealthNews?@"/api/article/health/information/":@"/api/article/health/direction/";
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@%@",url,self.bannerAim] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            if (self.articleType == ZPArticleTypeHealthNews) {
                weakSelf.healthNewsModel = [UHHealthNewsModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                weakSelf.headerView.healthNewsModel = weakSelf.healthNewsModel;
            } else {
                weakSelf.windModel = [UHHealthWindModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                weakSelf.headerView.model = weakSelf.windModel;
            }
            
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHArticleCommentListController class]];
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
    
    return self.datas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHArticleCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHArticleCommentListCell class])];
    UHArticleCommentModel *model = self.datas[indexPath.row];
    cell.model = model;
    cell.likeBlock = ^(UIButton *btn){

        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"comment/like" parameters:@{@"commentId":model.commentId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if ([model.articleCommentLikeState.name isEqualToString:@"LIKE"]) {
                     model.articleCommentLikeState.name = @"DISLIKE";
                } else {
                     model.articleCommentLikeState.name = @"LIKE";
                }
                model.likeCounts = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHArticleCommentListController class]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHArticleCommentModel *model = self.datas[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHArticleCommentListCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - CLBottomCommentViewDelegate
- (void)cl_textViewDidChange:(CLTextView *)textView {
    if (textView.commentTextView.text.length > 0) {
//        NSString *originalString = [NSString stringWithFormat:@"[草稿]%@",textView.commentTextView.text];
//        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:originalString];
//        [attriString addAttributes:@{NSForegroundColorAttributeName: kColorNavigationBar} range:NSMakeRange(0, 4)];
//        [attriString addAttributes:@{NSForegroundColorAttributeName: kColorTextMain} range:NSMakeRange(4, attriString.length - 4)];
//
//        self.bottomView.editTextField.attributedText = attriString;
    }
}

- (void)cl_textViewDidEndEditing:(CLTextView *)textView {
    if (textView.commentTextView.text.length) {
        [MBProgressHUD showMessage:@"发送中"];
        WEAK_SELF(weakSelf);
        NSString *articleId;
        NSString *articleType;
        if (self.articleType == ZPArticleTypeWind) {
            articleId = self.windModel.directionId;
            articleType = @"HEALTH_DIRECTION";
        } else {
            articleId = self.healthNewsModel.informationId;
            articleType = @"HEALTH_INFORMATION";
        }
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/article/comment" andHTTPMethod:@"PUT" andDict:@{@"articleId":articleId,@"articleType":articleType,@"commentContent":textView.commentTextView.text} success:^(NSDictionary *response) {
            UHUserModel *usermodel = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
            UHArticleCommentModel *model = [[UHArticleCommentModel alloc] init];
            model.commentId = [[response objectForKey:@"data"] objectForKey:@"commentId"];
            model.commentContent = textView.commentTextView.text;
            model.commentTime = [[response objectForKey:@"data"] objectForKey:@"commentTime"];
            model.likeCounts = @"0";
            model.isNewComment = YES;
            model.customerPortrait = usermodel.portrait;
            model.customerName = usermodel.nickName;
            
            if (weakSelf.articleType == ZPArticleTypeWind) {
               NSInteger num = [weakSelf.windModel.toatalCommentsCount integerValue];
                num++;
                weakSelf.windModel.toatalCommentsCount = [NSString stringWithFormat:@"%ld",num];
                weakSelf.headerView.model = weakSelf.windModel;
            } else {
                NSInteger num = [weakSelf.healthNewsModel.toatalCommentsCount integerValue];
                num++;
                weakSelf.healthNewsModel.toatalCommentsCount = [NSString stringWithFormat:@"%ld",num];
                weakSelf.headerView.healthNewsModel = weakSelf.healthNewsModel;
            }
            
            [weakSelf.datas insertObject:model atIndex:0];
            [weakSelf.tableView reloadData];
            [weakSelf.bottomView clearComment];
            [MBProgressHUD showSuccess:@"评论成功!"];
//            weakSelf.orderByType = ZPOrderByTypeTime;
//            [weakSelf.tableView.mj_header beginRefreshing];
        } failed:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHArticleCommentListCell class] forCellReuseIdentifier:NSStringFromClass([UHArticleCommentListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (CLBottomCommentView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CLBottomCommentView alloc] initWithFrame:CGRectMake(0, cl_ScreenHeight - kBottomViewHeight-kSafeAreaTopHeight, cl_ScreenWidth, kBottomViewHeight)];
        _bottomView.delegate = self;
        _bottomView.clTextView.delegate = self;
       
    }
    return _bottomView;
}

@end
