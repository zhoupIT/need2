//
//  UHStatisticsView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHStatisticsView.h"

@interface UHStatisticsView()
@property (strong, nonatomic) IBOutlet UILabel *lowerBloodCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *normalBloodCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *normalHighBloodCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *oneHighBloodCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoHighBloodCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeBloodCountLabel;
@end
@implementation UHStatisticsView

+ (instancetype)statisticsView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"UHStatisticsView" owner:nil options:nil];
    return [nibView firstObject];
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.lowerBloodCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"lowerBloodCount"]];
    self.normalBloodCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"normalBloodCount"]];
    self.normalHighBloodCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"normalHighBloodCount"]];
    self.oneHighBloodCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"oneHighBloodCount"]];
    self.twoHighBloodCountLabel.text =[NSString stringWithFormat:@"%@",dict[@"twoHighBloodCount"]];
    self.threeBloodCountLabel.text = [NSString stringWithFormat:@"%@",dict[@"threeBloodCount"]];
}
@end
