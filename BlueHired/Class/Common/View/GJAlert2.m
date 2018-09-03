//
//  GJAlert.m
//  GJPersonal
//
//  Created by zab on 16/1/15.
//  Copyright © 2016年 xinyi. All rights reserved.
//

#import "GJAlert2.h"
//#import "PureLayout.h"

#define coverColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@protocol GJAlertViewDelegate <NSObject>
@optional
- (void)buttonClick:(NSInteger)buttonIndex;

- (void)contentViewClick;

@end

@interface GJAlertView2 : UIView
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *alertView;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSArray *buttonTitles;
@property(nonatomic,strong)NSArray *buttonColors;

@property(nonatomic,strong)id<GJAlertViewDelegate>delegate;

- (void)showAlert;
- (void)hideAlert;
@end
@implementation GJAlertView2
- (void)setupCoverView{
    self.coverView = [[UIView alloc] initWithFrame:self.frame];
    self.coverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.coverView];
}
- (void)setupContentView{
    
    self.alertView = [[UIView alloc]init];
    [self addSubview:_alertView];
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.center.equalTo(self);
    }];
//    [_alertView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:30.0];
//    [_alertView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-30.0];
//    [_alertView autoCenterInSuperview];
    [_alertView setBackgroundColor:[UIColor whiteColor]];
//    _alertView.layer.cornerRadius = 8.0;
    
    UIView *v = [[UIView alloc]init];
    [self.alertView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
        v.backgroundColor = [UIColor baseColor];
    }];
    
    
//    UIImageView *imageview = [[UIImageView alloc] init];
//    [_alertView addSubview:imageview];
//    [imageview autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_alertView withOffset:20.0];
//    [imageview autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [imageview autoSetDimensionsToSize:CGSizeMake(55.0, 55.0)];
//    [imageview setImage:[UIImage imageNamed:@"ic_mm_collectioncell"]];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [_alertView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
//    [labelTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_alertView withOffset:20.0];
//    [labelTitle autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_alertView withOffset:15.0];
//    [labelTitle autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_alertView withOffset:-15.0];
//    [labelTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    labelTitle.text = _title;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:17];
    labelTitle.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    labelTitle.numberOfLines = 0;
    
    
    UIView *line0 = [[UIView alloc]init];
    [_alertView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    //    [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:labelMessage withOffset:15.0];
    //    [line autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_alertView withOffset:0];
    //    [line autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_alertView withOffset:0];
    //    [line autoSetDimension:ALDimensionHeight toSize:1];
    line0.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    
    UIView *messageContentView = [[UIView alloc]init];
    [_alertView addSubview:messageContentView];
    [messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
//    [messageContentView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_alertView withOffset:15.0];
//    [messageContentView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_alertView withOffset:-15.0];
//    [messageContentView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:labelTitle withOffset:10.0];
    
    UILabel *labelMessage = [[UILabel alloc]init];
    [_alertView addSubview:labelMessage];
    [labelMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(30);
        make.bottom.mas_equalTo(-70);
    }];
//    [labelMessage autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:messageContentView];
//    [labelMessage autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:messageContentView];
//    [labelMessage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:messageContentView];
    //[labelMessage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:messageContentView];
    labelMessage.text = _message;
//    labelMessage.textAlignment = NSTextAlignmentLeft;
    labelMessage.font = [UIFont systemFontOfSize:16];
    labelMessage.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    labelMessage.numberOfLines = 0;
    
    
    

    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:labelMessage.text];

    NSRange range1 = NSMakeRange(0, labelMessage.text.length);
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 10;
    [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range1];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B1B1B"] range:range1];
    
    NSRange range = NSMakeRange(labelMessage.text.length-18, 18);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:range];

    labelMessage.attributedText = noteStr;
    
    
    
    CGFloat spacing = 10.0;
    CGFloat marginleft = 20.0;
    
    UIView *line = [[UIView alloc]init];
    [_alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelMessage.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-42);
    }];
//    [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:labelMessage withOffset:15.0];
//    [line autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_alertView withOffset:0];
//    [line autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_alertView withOffset:0];
//    [line autoSetDimension:ALDimensionHeight toSize:1];
    line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];

//    if (_buttonTitles.count == 2) {
//        UIView *lin = [[UIView alloc]init];
//        [_alertView addSubview:lin];
//        [lin mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(line.mas_bottom).offset(0);
//            make.centerY.equalTo(self.alertView);
//            make.width.mas_equalTo(1);
//            make.height.mas_equalTo(32);
//            make.bottom.mas_equalTo(0);
//        }];
////        [lin autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line withOffset:5.0];
////        [lin autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_alertView withOffset:-5.0];
////        [lin autoAlignAxisToSuperviewAxis:ALAxisVertical];
////        [lin autoSetDimension:ALDimensionWidth toSize:1];
//        lin.backgroundColor = [UIColor baseColor];
//    }
    

    
    CGFloat buttonWidth = (self.frame.size.width - marginleft*2 - 60 - (_buttonTitles.count - 1)*spacing)/_buttonTitles.count;
    CGFloat leadingX = 0.0;
    NSInteger i = 0;
    
    NSArray *imgArray = @[@"copy_img",@"call_phone"];
    
    for (NSString *btnTitle in _buttonTitles) {
        leadingX = buttonWidth * i + spacing *i + marginleft;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leadingX);
            make.bottom.mas_equalTo(0);
            make.top.equalTo(line.mas_bottom).offset(0);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(42);
        }];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
//        [button autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_alertView withOffset:leadingX];
//        [button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_alertView withOffset:-10.0];
//        [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line withOffset:10.0];
//        [button autoSetDimension:ALDimensionWidth toSize:buttonWidth];
        [button setTitle:btnTitle forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        if (_buttonColors && _buttonColors.count > i) {
//            [button setBackgroundColor:[_buttonColors objectAtIndex:i]];
            [button setTitleColor:[_buttonColors objectAtIndex:i] forState:UIControlStateNormal];

        }
        button.layer.cornerRadius = 3.0;
        [button addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        i++;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismiss:)];
    [_coverView addGestureRecognizer:tap];
}
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles;
        self.buttonColors = buttonColors;
        [self setupCoverView];
        [self setupContentView];
    }
    return self;
}

- (void)showAlert{
    
    CGFloat duration = 0.3;
    self.coverView.alpha = 0.0;
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.coverView.alpha = 0.7;
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
//    self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    } completion:^(BOOL finished) {
//    }];

    
  
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    animation.values = @[@(1.3), @(1.0)];
//    animation.keyTimes = @[@(0), @(1.0)];
//    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    animation.duration = duration;
//    [self.alertView.layer addAnimation:animation forKey:@"bouce"];
  
}

- (void)hideAlert{
    CGFloat duration = 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.coverView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished) {
        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)tapDismiss:(UITapGestureRecognizer *)recognizer{
    if ([_delegate respondsToSelector:@selector(contentViewClick)]) {
        [_delegate contentViewClick];
    }
}
- (void)btnTap:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(buttonClick:)]) {
        [_delegate buttonClick:button.tag];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        self.delegate = nil;
    }
}

- (void)dealloc{
    NSLog(@"GJAlertView Delloc");
}
@end

@interface GJAlert2 ()<GJAlertViewDelegate>
@property(nonatomic,strong)GJAlertView2 *gjAlertView;
@property(nonatomic,copy)AlertBlock alertBlock;

@end
@implementation GJAlert2
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonClick:(void(^)(NSInteger buttonIndex))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertView2 alloc] initWithTitle:title message:message buttonTitles:buttonTitles buttonsColor:buttonColors];
        self.gjAlertView.delegate = self;
        self.alertBlock = block;
    }
    return self;
}
- (void)showAlertHandle{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow makeKeyAndVisible];
    [keywindow addSubview:self.gjAlertView];
    [self.gjAlertView showAlert];
}
- (void)show{
    [self showAlertHandle];
}
- (void)dismiss{
    [self.gjAlertView hideAlert];
}

#pragma mark GJAlertViewDelegate
- (void)contentViewClick{
    [self dismiss];
}
- (void)buttonClick:(NSInteger)buttonIndex{
    __weak typeof(self) weakSelf = self;
    if (_alertBlock) {
        _alertBlock(buttonIndex);
        [weakSelf dismiss];
    }
}
- (void)dealloc{
    NSLog(@"GJAlert Delloc");
}

@end
