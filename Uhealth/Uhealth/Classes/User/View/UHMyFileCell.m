//
//  UHMyFileCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileCell.h"
#import "UHMyFileModel.h"
@interface UHMyFileCell()

@property (strong, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locLabel;

@end
@implementation UHMyFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailBtn.layer.borderWidth = 0.5;
    self.detailBtn.layer.borderColor = KCommonBlue.CGColor;
}
- (IBAction)detailClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setModel:(UHMyFileModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.timeLabel.text = model.detectDate;
    self.locLabel.text = model.subordindateUnit;
}

@end
