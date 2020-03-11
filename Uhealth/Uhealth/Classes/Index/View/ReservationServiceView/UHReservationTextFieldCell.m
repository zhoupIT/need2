//
//  UHReservationTextFieldCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHReservationTextFieldCell.h"

#import "HSSetTableViewController.h"

@interface UHReservationTextFieldCell()<UITextFieldDelegate>
@property (nonatomic, weak)UITextField *textField;  ///<
@property (nonatomic, weak)UILabel *label;  ///<
@end
@implementation UHReservationTextFieldCell

+ (HSBaseTableViewCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView
{
    UHReservationTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        //这里重写父类方法 仅仅是因为需要改写下cell样式，实际情况可以自己管理布局
        cell = [[UHReservationTextFieldCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)setupUI
{
    [super setupUI];
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(HS_SCREEN_WIDTH- 100 - HS_KCellMargin, (60 - 14)/2-5, 100, 14)];
    
    textfield.textColor = ZPMyOrderDetailFontColor;
    textfield.placeholder = @"请输入联系方式";
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.keyboardType = UIKeyboardTypePhonePad;
    textfield.tag = 10011;
    [self.contentView addSubview:textfield];
    self.textField = textfield;
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(IS_IPhone6P?HS_KCellMargin+5:HS_KCellMargin, (60 - 14)/2-5, 100, 14)];
    label.textColor = ZPMyOrderDetailFontColor;
    label.font = HS_KTitleFont;
    [self.contentView addSubview:label];
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:@"联系方式*"];
    [Str addAttribute:NSForegroundColorAttributeName value:ZPMyOrderDetailFontColor range:NSMakeRange(0, 3)];
    [Str addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:14] range:NSMakeRange(0, 5)];
    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,1)];
    label.attributedText = Str;
    self.label = label;
    
}


- (void)setupDataModel:(HSCustomCellModel *)model
{
    [super setupDataModel:model];
}



@end
