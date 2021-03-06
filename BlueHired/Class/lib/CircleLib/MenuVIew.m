//
//  MenuVIew.m
//  mytest
//
//  Created by 易云时代 on 2017/7/18.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import "MenuVIew.h"
#import "UIView+SDAutoLayout.h"
//#import "GlobalDefines.h"

@implementation MenuVIew
{
    UIButton *_likeButton;
    UIButton *_commentButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = LENGTH_SIZE(15);
    self.backgroundColor = [UIColor colorWithRed:69/255.0 green:74/255.0 blue:76/255.0 alpha:1];
    
    _likeButton = [self creatButtonWithTitle:@"点赞" image:[UIImage imageNamed:@"喜欢 (1)"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"对话 (2)"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor clearColor];
    
    
    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 5;
    
    _likeButton.sd_layout
    .leftSpaceToView(self, margin)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(60);
    
    centerLine.sd_layout
    .leftSpaceToView(_likeButton, margin)
    .topSpaceToView(self, margin)
    .bottomSpaceToView(self, margin)
    .widthIs(1);
    
    _commentButton.sd_layout
    .leftSpaceToView(centerLine, margin)
    .topEqualToView(_likeButton)
    .bottomEqualToView(_likeButton)
    .widthRatioToView(_likeButton, 1);
    
    
}
- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
    self.show = NO;
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (void)setPraise:(BOOL)Praise{
    if (Praise) {
        [_likeButton setTitle:@"点赞" forState:UIControlStateNormal];
    }else{
        [_likeButton setTitle:@"取消" forState:UIControlStateNormal];
    }
}

- (void)setShow:(BOOL)show
{
    _show = show;
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            [self clearAutoWidthSettings];
            self.sd_layout
            .widthIs(0);
        } else {
            self.fixedWidth = nil;
            [self setupAutoWidthWithRightView:self->_commentButton rightMargin:5];
        }
        [self updateLayoutWithCellContentView:self.superview];
    }];
}

@end
