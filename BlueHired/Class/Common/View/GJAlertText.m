//
//  GJAlertText.m
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "GJAlertText.h"

#define coverColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@protocol GJAlertViewTextDelegate <NSObject>
@optional
- (void)buttonClick:(NSInteger)buttonIndex string:(NSString *)string;

- (void)contentViewClick;

@end

@interface GJAlertViewText : UIView
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *alertView;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSArray *buttonTitles;
@property(nonatomic,strong)NSArray *buttonColors;
@property(nonatomic,assign) NSInteger MacLength;
@property(nonatomic,strong)NSString *NilTitle;

@property(nonatomic,strong) NSString *textFieldString;
@property(nonatomic,strong)id<GJAlertViewTextDelegate>delegate;

- (void)showAlert;
- (void)hideAlert;
@end
@implementation GJAlertViewText
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
        v.backgroundColor = [UIColor baseColor];
    }];
    
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
    
    
    UIView *line0 = [[UIView alloc]init];
    [_alertView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    line0.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    
    UIView *messageContentView = [[UIView alloc]init];
    [_alertView addSubview:messageContentView];
    [messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    UITextField *textField = [[UITextField alloc]init];
    [_alertView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-70);
        make.height.mas_equalTo(35);
    }];
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5.0;
    textField.placeholder = _message;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    textField.font = [UIFont systemFontOfSize:16];
    
//    UILabel *labelMessage = [[UILabel alloc]init];
//    [_alertView addSubview:labelMessage];
//    [labelMessage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelTitle.mas_bottom).offset(30);
//        make.left.mas_equalTo(30);
//        make.right.mas_equalTo(30);
//        make.bottom.mas_equalTo(-70);
//    }];
//    labelMessage.text = _message;
//    labelMessage.font = [UIFont systemFontOfSize:16];
//    labelMessage.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
//    labelMessage.numberOfLines = 0;
    
    
    
    CGFloat spacing = 10.0;
    CGFloat marginleft = 20.0;
    
    UIView *line = [[UIView alloc]init];
    [_alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-42);
    }];
    line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    CGFloat buttonWidth = (self.frame.size.width - marginleft*2 - 60 - (_buttonTitles.count - 1)*spacing)/_buttonTitles.count;
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
            
        }
        button.layer.cornerRadius = 3.0;
        [button addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        i++;
    }
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismiss:)];
//    [_coverView addGestureRecognizer:tap];
}
-(void)textFieldChanged:(UITextField *)textField{
//
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
     int kMaxLength = self.MacLength;
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    self.textFieldString = textField.text;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors MaxLength:(NSInteger) Length NilTitel:(NSString *) NilTitle{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles;
        self.buttonColors = buttonColors;
        self.MacLength = Length;
        self.NilTitle = NilTitle;
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
    if (button.tag && self.textFieldString.length==0) {
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:self.NilTitle time:1.0];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(buttonClick:string:)]) {
        [_delegate buttonClick:button.tag string:self.textFieldString];
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

@interface GJAlertText ()<GJAlertViewTextDelegate>
@property(nonatomic,strong)GJAlertViewText *gjAlertView;
@property(nonatomic,copy)AlertTextBlock alertTextBlock;

@end
@implementation GJAlertText
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors MaxLength:(NSInteger)Length NilTitel:(NSString *)NilTitel buttonClick:(void(^)(NSInteger buttonIndex , NSString * string))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertViewText alloc] initWithTitle:title message:message buttonTitles:buttonTitles buttonsColor:buttonColors MaxLength:Length NilTitel:NilTitel];
        self.gjAlertView.delegate = self;
        self.alertTextBlock = block;
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

#pragma mark GJAlertViewTextDelegate
- (void)contentViewClick{
    [self dismiss];
}
- (void)buttonClick:(NSInteger)buttonIndex string:(NSString *)string{
    __weak typeof(self) weakSelf = self;

    if (_alertTextBlock) {
        _alertTextBlock(buttonIndex , string);
        [weakSelf dismiss];
    }
}
- (void)dealloc{
    NSLog(@"GJAlert Delloc");
}

@end
