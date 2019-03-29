//
//  GJAlertMessage.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "GJAlertMessage.h"

#define coverColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@protocol GJAlertViewMessageDelegate <NSObject>
@optional
- (void)buttonClick:(NSInteger)buttonIndex;

- (void)contentViewClick;

@end

@interface GJAlertViewMessage : UIView
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *alertView;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSMutableAttributedString *Mutabletitle;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,assign) NSTextAlignment textAlignment;
@property(nonatomic,strong)NSArray *buttonTitles;
@property(nonatomic,strong)NSArray *buttonColors;
@property(nonatomic,strong) NSArray *buttonsBackgroundColors;
@property(nonatomic,assign) BOOL isbackDismiss;
@property(nonatomic,assign) BOOL isShowHead;

@property(nonatomic,strong)id<GJAlertViewMessageDelegate>delegate;

- (void)showAlert;
- (void)hideAlert;
@end
@implementation GJAlertViewMessage
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
    [_alertView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *v = [[UIView alloc]init];
    [self.alertView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
//    v.backgroundColor = self.isShowHead?[UIColor whiteColor]:[UIColor baseColor];
    v.backgroundColor = [UIColor whiteColor];

    UILabel *labelTitle = [[UILabel alloc] init];
    [_alertView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    labelTitle.text = _title;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:17];
    labelTitle.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    labelTitle.numberOfLines = 0;
    
    
//    UIView *line0 = [[UIView alloc]init];
//    [_alertView addSubview:line0];
//    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelTitle.mas_bottom).offset(10);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(0.5);
//    }];
//
//    line0.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UILabel *labelMessage = [[UILabel alloc]init];
    [_alertView addSubview:labelMessage];
    [labelMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-62);
    }];
    labelMessage.text = _message;
    if (labelMessage.text) {
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:labelMessage.text];
        NSRange range1 = NSMakeRange(0, labelMessage.text.length);
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 10;
        [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range1];
        labelMessage.attributedText = noteStr;
    }
    labelMessage.textAlignment = _textAlignment;
    labelMessage.font = [UIFont systemFontOfSize:16];
    labelMessage.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    labelMessage.numberOfLines = 0;
    
    
    UIView *line = [[UIView alloc]init];
    [_alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-42);
    }];
    line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    
    CGFloat spacing = 0.0;
    CGFloat marginleft = 0.0;
    CGFloat buttonWidth = (self.frame.size.width - marginleft*2 - (self.isShowHead?96:60) - (_buttonTitles.count - 1)*spacing)/_buttonTitles.count;
    CGFloat leadingX = 0.0;
    NSInteger i = 0;
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
        [button setTitle:btnTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        if (_buttonColors && _buttonColors.count > i) {
            [button setTitleColor:[_buttonColors objectAtIndex:i] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        if (_buttonsBackgroundColors && _buttonsBackgroundColors.count > i) {
            button.backgroundColor = [_buttonsBackgroundColors objectAtIndex:i];
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
        [button addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        i++;
        if (self.isShowHead) {
            button.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
            button.layer.borderWidth = 0.5;
        }
    }
    
    if (self.isShowHead) {
        self.alertView.layer.cornerRadius = 6;
        [labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.left.mas_equalTo(29);
            make.right.mas_equalTo(-29);
        }];
        
        [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(48);
            make.right.mas_equalTo(-48);
            make.center.equalTo(self);
        }];
        
        [labelMessage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelTitle.mas_bottom).offset(32);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.bottom.mas_equalTo(-42);
        }];
        
        labelTitle.attributedText = _Mutabletitle;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismiss:)];
    [_coverView addGestureRecognizer:tap];
}


- (id)initWithTitle:(NSString *)title message:(NSString *)message textAlignment:(NSTextAlignment)textAlignment buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors  buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
        self.title = title;
        self.message = message;
        self.textAlignment = textAlignment;
        self.buttonTitles = buttonTitles;
        self.buttonColors = buttonColors;
        self.buttonsBackgroundColors = buttonsBackgroundColors;
        [self setupCoverView];
        [self setupContentView];
    }
    return self;
}

- (id)initWithTitle:(NSMutableAttributedString *)title message:(NSString *)message IsShowhead:(BOOL) Dis textAlignment:(NSTextAlignment)textAlignment buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors  buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
        self.Mutabletitle = title;
        self.message = message;
        self.textAlignment = textAlignment;
        self.buttonTitles = buttonTitles;
        self.buttonColors = buttonColors;
        self.buttonsBackgroundColors = buttonsBackgroundColors;
        self.isShowHead = Dis;

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
    if (self.isbackDismiss == NO) {
        return;
    }
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

@interface GJAlertMessage ()<GJAlertViewMessageDelegate>
@property(nonatomic,strong)GJAlertViewMessage *gjAlertView;
@property(nonatomic,copy)AlertMessageBlock AlertMessageBlock;

@end
@implementation GJAlertMessage
- (id)initWithTitle:(NSString *)title message:(NSString *)message textAlignment:(NSTextAlignment)textAlignment buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors buttonClick:(void (^)(NSInteger))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertViewMessage alloc] initWithTitle:title message:message textAlignment:textAlignment buttonTitles:buttonTitles buttonsColor:buttonColors buttonsBackgroundColors:buttonsBackgroundColors];
        self.gjAlertView.delegate = self;
        self.AlertMessageBlock = block;
        self.gjAlertView.isbackDismiss = YES;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message backDismiss:(BOOL) Dis textAlignment:(NSTextAlignment)textAlignment buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors buttonClick:(void(^)(NSInteger buttonIndex))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertViewMessage alloc] initWithTitle:title message:message textAlignment:textAlignment buttonTitles:buttonTitles buttonsColor:buttonColors buttonsBackgroundColors:buttonsBackgroundColors];
        self.gjAlertView.delegate = self;
        self.AlertMessageBlock = block;
    }
    return self;
}

- (id)initWithTitle:(NSMutableAttributedString *)title message:(NSString *)message IsShowhead:(BOOL) Dis textAlignment:(NSTextAlignment)textAlignment buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors buttonClick:(void(^)(NSInteger buttonIndex))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertViewMessage alloc] initWithTitle:title message:message IsShowhead:Dis textAlignment:textAlignment buttonTitles:buttonTitles buttonsColor:buttonColors buttonsBackgroundColors:buttonsBackgroundColors];
        self.gjAlertView.delegate = self;
        self.AlertMessageBlock = block;
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

#pragma mark GJAlertViewMessageDelegate
- (void)contentViewClick{
    [self dismiss];
}
- (void)buttonClick:(NSInteger)buttonIndex{
    __weak typeof(self) weakSelf = self;
    if (_AlertMessageBlock) {
        _AlertMessageBlock(buttonIndex);
        [weakSelf dismiss];
    }
}
- (void)dealloc{
    NSLog(@"GJAlert Delloc");
}

@end
