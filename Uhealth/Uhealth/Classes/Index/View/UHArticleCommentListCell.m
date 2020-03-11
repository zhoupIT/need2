//
//  UHArticleCommentListCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHArticleCommentListCell.h"
#import "UHArticleCommentModel.h"
@interface UHArticleCommentListCell()
{
    UIImageView *_customerPortraitView;
    UILabel *_customerNameLabel;
    UILabel *_commentTimeLabel;
    UILabel *_commentContentLabel;
    UIButton *_likeBtn;
    
}
@end
@implementation UHArticleCommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _customerPortraitView = [UIImageView new];
    _customerNameLabel = [UILabel new];
    _commentTimeLabel = [UILabel new];
    _commentContentLabel = [UILabel new];
    _likeBtn = [UIButton new];
    
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_customerPortraitView,_customerNameLabel,_commentTimeLabel,_commentContentLabel,_likeBtn]];
    _customerPortraitView.sd_layout
    .leftSpaceToView(contentView, 15)
    .widthIs(44)
    .heightIs(44)
    .topSpaceToView(contentView, 15);
    _customerPortraitView.contentMode = UIViewContentModeScaleAspectFill;
    _customerPortraitView.layer.cornerRadius = 22;
    _customerPortraitView.layer.masksToBounds = YES;
    
    _customerNameLabel.sd_layout
    .leftSpaceToView(_customerPortraitView, 10)
    .topEqualToView(_customerPortraitView)
    .heightIs(13);
    [_customerNameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _customerNameLabel.textColor = ZPMyOrderDetailFontColor;
    _customerNameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    
    _commentTimeLabel.sd_layout
    .topSpaceToView(_customerNameLabel, 15)
    .leftSpaceToView(_customerPortraitView, 10)
    .heightIs(12)
    .rightSpaceToView(contentView, 15);
    _commentTimeLabel.textColor = ZPMyOrderDeleteBorderColor;
    _commentTimeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    
    _commentContentLabel.sd_layout
    .topSpaceToView(_commentTimeLabel, 15)
    .leftSpaceToView(_customerPortraitView, 10)
    .autoHeightRatio(0)
    .rightSpaceToView(contentView, 15);
    _commentContentLabel.textColor = ZPMyOrderDetailFontColor;
    _commentContentLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    
    _likeBtn.sd_layout
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(_customerNameLabel)
    .heightIs(20);
    _likeBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 2.5, 0, 0);
    _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5);
    [_likeBtn setImage:[UIImage imageNamed:@"healthNews_like_icon"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"healthNews_likeSel_icon"] forState:UIControlStateSelected];
    _likeBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    [_likeBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupAutoHeightWithBottomView:_commentContentLabel bottomMargin:15];
}

- (void)setModel:(UHArticleCommentModel *)model {
    _model = model;
    [_customerPortraitView sd_setImageWithURL:[NSURL URLWithString:model.customerPortrait] placeholderImage:[UIImage imageNamed:@"user_male"]];
    _customerNameLabel.text = model.customerName;
    _commentTimeLabel.text = model.commentTime;
    _commentContentLabel.text = model.commentContent;
    CGSize size = MULTILINE_TEXTSIZE(model.likeCounts,[UIFont fontWithName:ZPPFSCRegular size:12] , CGSizeMake(MAXFLOAT, 10));
    _likeBtn.sd_layout.widthIs(size.width+25);
    [_likeBtn setTitle:model.likeCounts forState:UIControlStateNormal];
    if ([model.articleCommentLikeState.name isEqualToString:@"DISLIKE"]) {
        _likeBtn.selected = NO;
    } else {
        _likeBtn.selected = YES;
    }
    if (model.isNewComment) {
        self.backgroundColor = KControlColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)likeAction:(UIButton *)btn {
    if (self.likeBlock) {
        self.likeBlock(btn);
    }
}
@end
