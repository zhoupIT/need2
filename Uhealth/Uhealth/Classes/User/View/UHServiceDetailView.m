//
//  UHServiceDetailView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHServiceDetailView.h"
#import "UHMyServiceModel.h"
@interface UHServiceDetailView()
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *discountedPrice;
@property (strong, nonatomic) IBOutlet UILabel *finalPrice;

@end
@implementation UHServiceDetailView

+ (instancetype)addServiceDetailView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"UHServiceDetailView" owner:nil options:nil];
    return [nibView firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.backView.layer.cornerRadius = 4;
    self.backView.layer.borderWidth = 0.5;
    self.backView.layer.borderColor = ZPMyOrderDeleteBorderColor.CGColor;
    self.backView.layer.masksToBounds = YES;
}

- (void)setModel:(UHMyServiceModel *)model {
    _model = model;
    self.price.text = model.originProductAmountTotal;
    self.discountedPrice.text = model.reducedPrice;
    self.finalPrice.text = model.orderAmountTotal;
}
@end
