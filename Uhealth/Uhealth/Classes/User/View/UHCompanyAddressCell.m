//
//  UHCompanyAddressCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCompanyAddressCell.h"

@interface UHCompanyAddressCell()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation UHCompanyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.textView.contentInset = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
