////
////  UHMyOrderCell.m
////  Uhealth
////
////  Created by Biao Geng on 2018/3/29.
////  Copyright © 2018年 Peng Zhou. All rights reserved.
////
//
//#import "UHMyOrderCell.h"
//#import "tempClass.h"
//#import "UHCommentView.h"
//#import "UHOrderModel.h"
//#import "UHOrderItemModel.h"
//@interface UHMyOrderCell()
//@property (strong, nonatomic) IBOutlet UIButton *confirmGetOrderBtn;
//@property (strong, nonatomic) IBOutlet UIButton *deleteOrderBtn;
//@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
//@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
//@property (strong, nonatomic) IBOutlet UIView *backView;
//@end
//@implementation UHMyOrderCell
//
//+ (instancetype)cellWithTabelView:(UITableView *)tableView {
//    UHMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyOrderCell class])];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHMyOrderCell class]) owner:nil options:nil] firstObject];
//        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//        [cell setupUI];
//    }
//    return cell;
//}
//
//- (void)setupUI {
//    self.confirmGetOrderBtn.layer.masksToBounds = YES;
//    self.confirmGetOrderBtn.layer.cornerRadius = 5;
//    self.confirmGetOrderBtn.layer.borderColor = ZPMyOrderBorderColor.CGColor;
//    self.confirmGetOrderBtn.layer.borderWidth = 1;
//    
//    self.orderImageView.layer.cornerRadius = 5;
//    self.orderImageView.layer.masksToBounds = YES;
//    
//    self.deleteOrderBtn.layer.masksToBounds = YES;
//    self.deleteOrderBtn.layer.cornerRadius = 5;
//    self.deleteOrderBtn.layer.borderColor = ZPMyOrderDeleteBorderColor.CGColor;
//    self.deleteOrderBtn.layer.borderWidth = 1;
//    
//    self.backView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailEvent)];
//    [self.backView addGestureRecognizer:tap];
//    
//}
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//}
//
//- (void)detailEvent {
//    ZPLog(@"detailEvent");
////    if (self.detailClickBlock) {
////        self.detailClickBlock();
////    }
//}
//
//- (IBAction)doGetOrder:(UIButton *)sender {
//    
//    if ([sender.titleLabel.text isEqualToString:@"评价"]) {
//        
//        UHCommentView *view = [[UHCommentView alloc] initWithFrame:CGRectMake(0, 0, 302, 0)];
//        
//        view.closeBlock = ^{
//            
//            [LEEAlert closeWithCompletionBlock:nil];
//        };
//        view.updateBlock = ^(NSInteger count, NSString *content) {
//            [LEEAlert closeWithCompletionBlock:^{
//                  [EBBannerView showWithContent:[NSString stringWithFormat:@"您给出了%ld颗星,评价的内容是%@",count,content]];
//            }];
//        };
//        
//        [LEEAlert alert].config
//        .LeeCustomView(view)
//        .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
//        .LeeShow();
//
//    } else {
//        [EBBannerView showWithContent:sender.titleLabel.text];
//    }
//}
//
//- (IBAction)doDeleteOrder:(UIButton *)sender {
//     [EBBannerView showWithContent:sender.titleLabel.text];
//}
//
////- (void)setTempClass:(tempClass *)tempClass {
////    _tempClass = tempClass;
////    switch (tempClass.ordertype) {
////        case 0:
////            {
////                self.orderStatusLabel.text = @"待支付";
////                self.deleteOrderBtn.hidden = NO;
////                [self.confirmGetOrderBtn setTitle:@"立即支付" forState:UIControlStateNormal];
////            }
////            break;
////        case 1:
////            {
////                self.orderStatusLabel.text = @"待发货";
////                self.deleteOrderBtn.hidden = YES;
////                self.confirmGetOrderBtn.hidden = YES;
//////                if (self.updateCellHeightBlock) {
//////                    self.updateCellHeightBlock();
//////                }
////
////            }
////            break;
////        case 2:
////            {
////                self.orderStatusLabel.text = @"待收货";
////                self.deleteOrderBtn.hidden = YES;
////                [self.confirmGetOrderBtn setTitle:@"确认收货" forState:UIControlStateNormal];
////            }
////            break;
////        case 3:
////            {
////                self.orderStatusLabel.text = @"交易成功";
////                self.deleteOrderBtn.hidden = NO;
////                [self.confirmGetOrderBtn setTitle:@"评价" forState:UIControlStateNormal];
////            }
////            break;
////            
////        default:
////            break;
////    }
////}
////
////- (void)setModel:(UHOrderModel *)model {
////    _model = model;
////    self.orderStatusLabel.text = model.orderStatus;
////    self.deleteOrderBtn.hidden = NO;
////    [self.confirmGetOrderBtn setTitle:@"立即支付" forState:UIControlStateNormal];
////    
////}
//@end
