//
//  GJAlertPassword.m
//  BlueHired
//
//  Created by peng on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "GJAlertPassword.h"

#define coverColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@protocol GJAlertViewPasswordDelegate <NSObject>
@optional
- (void)buttonClick:(NSInteger)buttonIndex string:(NSString *)string;

- (void)contentViewClick;

@end

@interface GJAlertViewPassword : UIView
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *alertView;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSArray *buttonTitles;
@property(nonatomic,strong)NSArray *buttonColors;

@property(nonatomic,strong) UITextField *textField;

@property(nonatomic,strong) NSString *textFieldString;
@property(nonatomic,strong)id<GJAlertViewPasswordDelegate>delegate;

@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

- (void)showAlert;
- (void)hideAlert;
@end
@implementation GJAlertViewPassword
- (void)setupCoverView{
    self.coverView = [[UIView alloc] initWithFrame:self.frame];
    self.coverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.coverView];
}
- (void)setupContentView{
    
    self.alertView = [[UIView alloc]init];
    [self addSubview:_alertView];
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
//        make.center.equalTo(self);
        make.top.mas_equalTo(35);
    }];
    [_alertView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *deleteBt = [[UIButton alloc] init];
    [self.alertView addSubview:deleteBt];
    [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(26);
    }];
//    [deleteBt setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [deleteBt setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [deleteBt addTarget:self action:@selector(tapDismissBT:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *HeadTitleLable = [[UILabel alloc] init];
    [self.alertView addSubview:HeadTitleLable];
    [HeadTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(deleteBt.mas_right).offset(8);
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    HeadTitleLable.text = @"身份验证";
    HeadTitleLable.font = [UIFont systemFontOfSize:16];
    
    
    UIView *v = [[UIView alloc]init];
    [self.alertView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(0.5);
    }];
    v.backgroundColor = [UIColor baseColor];

    UILabel *labelTitle = [[UILabel alloc] init];
    [_alertView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
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
    
    line0.backgroundColor = [UIColor clearColor];
    
    
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
        make.top.equalTo(labelTitle.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-70);
        make.height.mas_equalTo(48);
    }];
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5.0;
    textField.placeholder = _message;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.textColor = [UIColor clearColor];
    textField.tintColor = [UIColor clearColor];
    [textField becomeFirstResponder];
    self.textField = textField;
    
    self.labelArray = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        [self.labelArray addObject:label];
        [textField addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
    }
    [self.labelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [self.labelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    NSMutableArray *viewarray = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"#AAAAAA"];
        [viewarray addObject:view];
        [textField addSubview:view];
    }
    [viewarray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:(SCREEN_WIDTH-50)/6-1 leadSpacing:0 tailSpacing:0];
    [viewarray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
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
    line.backgroundColor = [UIColor clearColor];
    
    CGFloat buttonWidth = (self.frame.size.width - marginleft*2 - 30 - (_buttonTitles.count - 1)*spacing)/_buttonTitles.count;
    CGFloat leadingX = 0.0;
    NSInteger i = 0;
    
    
    for (NSString *btnTitle in _buttonTitles) {
        leadingX = buttonWidth * i + spacing *i + marginleft;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leadingX);
//            make.top.equalTo(textField.mas_bottom).offset(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(42);
        }];
        [button setTitle:btnTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        if (_buttonColors && _buttonColors.count > i) {
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
-(void)textFieldChanged:(UITextField *)textField{
    for (UILabel *label in self.labelArray) {
        label.text = @"";
    }
    if (textField.text.length > 6) {
        return;
    }
    for (int i =0; i<textField.text.length; i++) {
//        self.labelArray[i].text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        self.labelArray[i].text = @"●";
    }
    
    self.textFieldString = textField.text;
    if (textField.text.length == 6) {
        if ([_delegate respondsToSelector:@selector(buttonClick:string:)]) {
            [_delegate buttonClick:0 string:self.textFieldString];
        }
    }
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
- (void)tapDismissBT:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(contentViewClick)]) {
        [_delegate contentViewClick];
    }
}

- (void)btnTap:(UIButton *)button{
    [self.textField resignFirstResponder];
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

@interface GJAlertPassword ()<GJAlertViewPasswordDelegate>
@property(nonatomic,strong)GJAlertViewPassword *gjAlertView;
@property(nonatomic,copy)GJAlertPasswordBlock alertTextBlock;

@end
@implementation GJAlertPassword
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonClick:(void(^)(NSInteger buttonIndex , NSString * string))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertViewPassword alloc] initWithTitle:title message:message buttonTitles:buttonTitles buttonsColor:buttonColors];
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
