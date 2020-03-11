//
//  UHOrderDetailTopCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHOrderDetailTopCell.h"
#import "UHCommodity.h"
@interface UHOrderDetailTopCell()
@property (strong, nonatomic) IBOutlet UILabel *preferpriceButton;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet UILabel *presentPricelabel;

@property (strong, nonatomic) IBOutlet UILabel *originalPricelabel;

@end

@implementation UHOrderDetailTopCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHOrderDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHOrderDetailTopCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHOrderDetailTopCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.preferpriceButton.layer.cornerRadius = 5;
    self.preferpriceButton.layer.borderColor = RGB(255, 150, 0).CGColor;
    self.preferpriceButton.layer.borderWidth = 1;
    self.preferpriceButton.layer.masksToBounds = YES;
}

- (void)setModel:(UHCommodity *)model {
    _model = model;
    self.namelabel.text = model.name;
    self.presentPricelabel.text = [NSString stringWithFormat:@"￥%@",model.presentPrice];
    self.originalPricelabel.text = model.originalPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.originalPricelabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
     self.originalPricelabel.attributedText = newPrice;
    
    self.preferpriceButton.text = model.priceName;
    
}

@end
