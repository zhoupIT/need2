//
//  UHGluView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGluView.h"

@interface UHGluView()
@property (strong, nonatomic) IBOutlet UILabel *lowerGluCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *normalGluCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *highGluCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *higherGluCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *highestGluCountLabel;
@end
@implementation UHGluView

+ (instancetype)statisticsView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"UHGluView" owner:nil options:nil];
    return [nibView firstObject];
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.lowerGluCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"lowerGluCount"]];
    self.normalGluCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"normalGluCount"]];
    self.highGluCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"highGluCount"]];
    self.higherGluCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"higherGluCount"]];
    self.highestGluCountLabel.text =[NSString stringWithFormat:@"%@",dict[@"highestGluCount"]];
}

@end
