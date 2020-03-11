//
//  UHHealthWindWebViewController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthWindWebViewController.h"
#import "UHUserModel.h"
#import <WebKit/WebKit.h>
#import <UShareUI/UShareUI.h>
#import "UHHealthWindModel.h"
#import "CLBottomCommentView.h"
#import "UHArticleCommentListController.h"
#import "WZLBadgeImport.h"
static CGFloat const kBottomViewHeight = 46.0;
@interface UHHealthWindWebViewController ()<WKUIDelegate,WKNavigationDelegate,CLBottomCommentViewDelegate>
@property (nonatomic,strong)  WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic, strong) CLBottomCommentView *bottomView;
@end

@implementation UHHealthWindWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllWk];
}

- (void)initAllWk {
    self.title = @"优医健康";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    //46
    self.wkWebView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 46, 0));
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self initWKProgressView];
    
    [self.view addSubview:self.bottomView];
    if (self.enterStatusType == ZPWindEnterStatusTypeBanner) {
        //从banner跳转过来 需要请求评论数量和模型
        [self getDataFromID:self.bannerAim];
    } else {
    NSInteger num = [self.windModel.commentCount integerValue];
    [self.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    }
    
}

- (void)initWKProgressView {
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,2)];
    [self.view addSubview:self.progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.enterStatusType != ZPWindEnterStatusTypeBanner) {
        [self getCommentNum];
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if(self.wkWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark - 分享
- (void)share {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self runShareWithType:platformType];
    }];
}

- (void)runShareWithType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.windModel.title descr:self.windModel.introduction thumImage:self.windModel.titleImgList.firstObject];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",self.urlStr,@"&isShow=true"];
//    shareObject.webpageUrl = @"http://192.168.8.13:8083/?from=singlemessage&isappinstalled=0#/healthyWindDirection/windDetailIos?id=1&isShow=true";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            ZPLog(@"************Share fail with error %@*********",error);
            [MBProgressHUD showError:@"分享失败"];
        }else{
            ZPLog(@"response data is %@",data);
            [MBProgressHUD showSuccess:@"分享成功"];
        }
    }];
}

- (void)getCommentNum {
    NSString *articleCommentOrderBy = @"COMMENT_TIME_DESC";
    NSString *articleType = @"HEALTH_DIRECTION";
    NSString *articleId = self.windModel.directionId;
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"article/comment" parameters:@{@"articleId":articleId,@"articleType":articleType,@"articleCommentOrderBy":articleCommentOrderBy} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.windModel.commentCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
            NSInteger num = [weakSelf.windModel.commentCount integerValue];
            [weakSelf.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHHealthWindWebViewController class]];
}

//通过banner传递来的iD来获取数据
- (void)getDataFromID:(NSString *)ID {
    WEAK_SELF(weakSelf);
    NSString *url = @"/api/article/health/direction/";
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@%@",url,ID] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.windModel = [UHHealthWindModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
//            [weakSelf getCommentNum];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHArticleCommentListController class]];
}

#pragma mark - CLBottomCommentViewDelegate
- (void)bottomViewDidShare {
    ZPLog(@"分享");
    [self share];
}

- (void)bottomViewDidComment:(UIButton *)markButton {
    ZPLog(@"评论");
    UHArticleCommentListController *commentListControl = [[UHArticleCommentListController alloc] init];
    commentListControl.articleType = ZPArticleTypeWind;
    if (self.enterStatusType == ZPWindEnterStatusTypeBanner) {
        commentListControl.bannerAim = self.bannerAim;
        commentListControl.enterStatusType = ZPCommentListEnterStatusTypeBanner;
        commentListControl.windModel = self.windModel;
    } else {
        commentListControl.windModel = self.windModel;
    }
    [self.navigationController pushViewController:commentListControl animated:YES];
}

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
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/article/comment" andHTTPMethod:@"PUT" andDict:@{@"articleId":self.windModel.directionId,@"articleType":@"HEALTH_DIRECTION",@"commentContent":textView.commentTextView.text} success:^(NSDictionary *response) {
        [weakSelf.bottomView clearComment];
        [MBProgressHUD showSuccess:@"评论成功!"];
        NSInteger num = [weakSelf.windModel.commentCount integerValue] + 1;
        weakSelf.windModel.commentCount = [NSString stringWithFormat:@"%ld",num];
        [weakSelf.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    } failed:^(NSError *error) {
     
    }];
    }
}

#pragma mark - Private Method
- (void)changeMarkButtonState:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - 懒加载
- (CLBottomCommentView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CLBottomCommentView alloc] initWithFrame:CGRectMake(0, cl_ScreenHeight - kBottomViewHeight-kSafeAreaTopHeight, cl_ScreenWidth, kBottomViewHeight)];
        _bottomView.delegate = self;
        _bottomView.clTextView.delegate = self;
    }
    return _bottomView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [WKWebView new];
    }
    return _wkWebView;
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

@end
