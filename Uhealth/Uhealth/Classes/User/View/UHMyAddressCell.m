//
//  UHMyAddressCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyAddressCell.h"
#import "UHAddressModel.h"

@interface UHMyAddressCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *locLabel;

@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *defaultBtn;

@end
@implementation UHMyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.editButton.imageView.sd_layout
    .heightIs(24)
    .heightIs(25)
    .centerYEqualToView(self.editButton);
    
    self.deleteButton.imageView.sd_layout
    .heightIs(24)
    .heightIs(25)
    .centerYEqualToView(self.deleteButton);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectLoc:(UIButton *)sender {
    if (self.selectAction) {
        self.selectAction();
    }
}

- (IBAction)editLoc:(UIButton *)sender {
    if (self.editAction) {
        self.editAction();
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    if (self.deleteAction) {
        self.deleteAction();
    }
}

- (void)setModel:(UHAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.receiver;
    self.phoneLabel.text = model.phone;
    self.locLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.provinceName,model.cityName,model.countryName,model.address];
    if ([model.addressStatus.name isEqualToString:@"DEFAULT"]) {
        self.defaultBtn.selected = YES;
    } else {
        self.defaultBtn.selected = NO;
    }
}

@end
