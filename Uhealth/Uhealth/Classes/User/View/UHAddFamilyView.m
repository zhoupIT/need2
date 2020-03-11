//
//  UHAddFamilyView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHAddFamilyView.h"

@interface UHAddFamilyView()
@property (strong, nonatomic) IBOutlet UIButton *sfzBtn;
@property (strong, nonatomic) IBOutlet UIButton *jrBtn;
@property (strong, nonatomic) IBOutlet UIButton *hzBtn;

@end

@implementation UHAddFamilyView

+ (instancetype)addFamilyView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"UHAddFamilyView" owner:nil options:nil];
    return [nibView firstObject];
}

- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.jrBtn.selected = NO;
    self.hzBtn.selected = NO;
}
- (IBAction)jrbtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sfzBtn.selected = NO;
    self.hzBtn.selected = NO;
}
- (IBAction)hzBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sfzBtn.selected = NO;
    self.jrBtn.selected = NO;
}

@end
