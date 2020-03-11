//
//  UHOrderCommentsController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHOrderCommentsController.h"
#import "UHOrderCommentsCell.h"
#import "UHCommentsModel.h"
@interface UHOrderCommentsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@end

@implementation UHOrderCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<20; i++) {
            UHCommentsModel *model = [[UHCommentsModel alloc] init];
            model.avaUrl = (i%2 == 1 ? @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523182728653&di=57c799c2309a37cff5ed5e094d6e3dd9&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201410%2F04%2F20141004134140_PmyWV.jpeg":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523182728653&di=7bad61f40a6db4f4ebfb64f6db703d0e&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201509%2F10%2F20150910104633_XBShw.jpeg");
            model.name = (i%2 == 1 ?@"韩相学":@"周鹏");
            model.time = (i%2 == 1 ?@"2018-04-12":@"2018-12-12");
            model.content = (i%2 == 1 ?@"价格优惠，服务周到，好评！":@"价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！价格优惠，服务周到，好评！");
            NSArray *temp1 = @[@"https://upload-images.jianshu.io/upload_images/1041928-376743cb91110863.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-8adda7541f54d2f6.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-6b5327ed85b3b1e1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
            NSArray *temp2 = @[@"https://upload-images.jianshu.io/upload_images/1041928-364c080328cb3c3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-954e4f739a3a2f35.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-5a7e9cd6d5495c7f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523184464356&di=ef67f6a0b9fec3daccd4d81acfda2a79&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D1682a2cca76eddc432eabcb851b2dc88%2F50da81cb39dbb6fd4a10690f0324ab18972b374b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523184464356&di=a63a48de113ca03a5afeff1e001985f0&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F95%2Fd%2F105.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523184464356&di=a3f9e84c210e12593b4a37732b00fc90&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F34fae6cd7b899e51fab3e9c048a7d933c8950d21.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523184464355&di=f07b7593619596245a6d145acd7c2ef0&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D356c0ad0c9fdfc03f175ebfbbc56ede1%2F9345d688d43f87945952b400d81b0ef41bd53a6b.jpg"];
            
            NSArray *temp3 = @[@"https://upload-images.jianshu.io/upload_images/1041928-376743cb91110863.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-8adda7541f54d2f6.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-6b5327ed85b3b1e1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/1041928-364c080328cb3c3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
            model.urlArray = (i%2 == 1 ?temp1:temp2);
            if (i == 4) {
                model.urlArray = temp3;
            }
            model.starNum = ((i+1) <6?i+1:1);
            [self.datas addObject:model];
        }
        [self.tableView reloadData];
        
    });
    
    
}

- (void)setupUI {
    
    self.title = @"评价";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    [self.tableView registerClass:[UHOrderCommentsCell class] forCellReuseIdentifier:NSStringFromClass([UHOrderCommentsCell class])];
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
    UHOrderCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHOrderCommentsCell class])];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHCommentsModel *model = self.datas[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHOrderCommentsCell class] contentViewWidth:SCREEN_WIDTH];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
