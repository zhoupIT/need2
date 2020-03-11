//
//  UHCheckOutModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutModel.h"

@implementation UHCheckOutModel
+ (NSMutableArray *)creatDetailsData {
    NSArray *titleArray = @[@"商店名称",@"11",@"购买数量",@"配送方式",@"配送时间",@"运费险",@"买家留言"];
    NSArray *detailsArray = @[@"111",@"111",@"",@"快递免费",@"周五送达",@"退货前可赔",@""];
    NSArray *cellTypeArray = @[
                               @(UHDetailsCellType_shop),
                               /// 商品
                               @(UHDetailsCellType_goods),
                               /// 输入数量
                               @(UHDetailsCellType_inputNums),
                               /// 配送方式
                               @(UHDetailsCellType_delivery),
                               /// 配送时间
                               @(UHDetailsCellType_time),
                               /// 运费险
                               @(UHDetailsCellType_insurance),
                               /// 留言
                               @(UHDetailsCellType_message)];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; index++) {
        
        UHCheckOutModel *model = [[UHCheckOutModel alloc]init];
        model.title = titleArray[index];
        model.details = detailsArray[index];
        NSNumber *typeNum = cellTypeArray[index];
        model.cellType = (UHDetailsCellType)typeNum.integerValue;
        if (model.cellType == UHDetailsCellType_goods) {
            model.cellHeight = 90;
        } else {
            model.cellHeight = 40;
        }
        [array addObject:model];
    }
    return array;
}
@end
