//
//  GJAlertWithDrawPassword.m
//  BlueHired
//
//  Created by iMac on 2019/1/24.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "GJAlertWithDrawPassword.h"
#define coverColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@protocol GJAlertViewPasswordDelegate <NSObject>
@optional
- (void)buttonClick:(NSInteger)buttonIndex string:(NSString *)string;

- (void)contentViewClick;

@end


@interface GJAlertWithDrawViewPassword : UIView
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *alertView;
@property(nonatomic,strong)NSMutableAttributedString *title;
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
@implementation GJAlertWithDrawViewPassword

- (void)setupCoverView{
    self.coverView = [[UIView alloc] initWithFrame:self.frame];
    self.coverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.coverView];
}
- (void)setupContentView{
    
    self.alertView = [[UIView alloc]init];
    [self addSubview:_alertView];
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(32));
        make.right.mas_equalTo(LENGTH_SIZE(-32));
//        if (SCREEN_WIDTH == 320) {
//            make.centerY.equalTo(self).offset(-30);
//        }else{
//            make.center.equalTo(self);
//        }
//        make.top.mas_equalTo(LENGTH_SIZE(32));
        
        make.centerY.equalTo(self).offset(LENGTH_SIZE(-100));
    }];
    [_alertView setBackgroundColor:[UIColor whiteColor]];
    _alertView.clipsToBounds = YES;
    
    
    UIButton *deleteBt = [[UIButton alloc] init];
    [self.alertView addSubview:deleteBt];
    [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(LENGTH_SIZE(10));
        make.right.mas_equalTo(LENGTH_SIZE(-10));
        make.height.width.mas_equalTo(LENGTH_SIZE(18));
    }];
    [deleteBt setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [deleteBt addTarget:self action:@selector(tapDismissBT:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *HeadTitleLable = [[UILabel alloc] init];
    [self.alertView addSubview:HeadTitleLable];
    [HeadTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(24));
    }];
    HeadTitleLable.text = @"请输入提现密码";
    HeadTitleLable.textAlignment = NSTextAlignmentCenter;
    HeadTitleLable.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    HeadTitleLable.textColor = [UIColor colorWithHexString:@"#333333"];
    
    
//    UIView *v = [[UIView alloc]init];
//    [self.alertView addSubview:v];
//    [v mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(40);
//        make.height.mas_equalTo(0);
//    }];
//    v.backgroundColor = [UIColor baseColor];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [_alertView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HeadTitleLable.mas_bottom).offset(LENGTH_SIZE(8));
        make.left.mas_equalTo(LENGTH_SIZE(28));
        make.right.mas_equalTo(LENGTH_SIZE(-28));
    }];
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = FONT_SIZE(15);
    labelTitle.textColor = [UIColor colorWithHexString:@"#999999"];
    labelTitle.numberOfLines = 0;
    labelTitle.attributedText = _title;

//    UILabel *labelMessageTitle = [[UILabel alloc] init];
//    [_alertView addSubview:labelMessageTitle];
//    [labelMessageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelTitle.mas_bottom).offset(0);
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//    }];
//
//    labelMessageTitle.text = _message;
//    labelMessageTitle.textAlignment = NSTextAlignmentCenter;
//    labelMessageTitle.font = [UIFont boldSystemFontOfSize:19];
//    labelMessageTitle.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
//    labelMessageTitle.numberOfLines = 0;
    
    
//    UIView *line0 = [[UIView alloc]init];
//    [_alertView addSubview:line0];
//    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelMessageTitle.mas_bottom).offset(10);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(0.5);
//    }];
//
//    line0.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//
    
//    UIView *messageContentView = [[UIView alloc]init];
//    [_alertView addSubview:messageContentView];
//    [messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelTitle.mas_bottom).offset(10);
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//    }];
    
    
    UITextField *textField = [[UITextField alloc]init];
    [_alertView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(LENGTH_SIZE(18));
        make.left.mas_equalTo(LENGTH_SIZE(24));
        make.right.mas_equalTo(LENGTH_SIZE(-24));
        make.bottom.mas_equalTo(LENGTH_SIZE(-55));
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5.0;
//    textField.placeholder = _message;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    textField.font = FONT_SIZE(16);
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
        view.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        [viewarray addObject:view];
        [textField addSubview:view];
    }
    [viewarray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:(SCREEN_WIDTH-LENGTH_SIZE(56*2))/6-1 leadSpacing:0 tailSpacing:0];
    [viewarray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    
    UIButton *ForgetBt = [[UIButton alloc] init];
    [_alertView addSubview:ForgetBt];
    [ForgetBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(textField.mas_bottom).offset(LENGTH_SIZE(10));
    }];
    ForgetBt.titleLabel.font = FONT_SIZE(15);
    [ForgetBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [ForgetBt setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [ForgetBt addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    
    

    
//    UIView *line = [[UIView alloc]init];
//    [_alertView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//        make.bottom.mas_equalTo(-42);
//    }];
//    line.backgroundColor = [UIColor clearColor];
    
//    CGFloat spacing = 10.0;
//    CGFloat marginleft = 20.0;
//    CGFloat buttonWidth = (self.frame.size.width - marginleft*2 - 30 - (_buttonTitles.count - 1)*spacing)/_buttonTitles.count;
//    CGFloat leadingX = 0.0;
//    NSInteger i = 0;
//
//
//    for (NSString *btnTitle in _buttonTitles) {
//        leadingX = buttonWidth * i + spacing *i + marginleft;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_alertView addSubview:button];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(leadingX);
//            make.top.equalTo(textField.mas_bottom).offset(0);
//            make.width.mas_equalTo(buttonWidth);
//            make.height.mas_equalTo(42);
//        }];
//        [button setTitle:btnTitle forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        if (_buttonColors && _buttonColors.count > i) {
//            [button setTitleColor:[_buttonColors objectAtIndex:i] forState:UIControlStateNormal];
//        }
//        button.layer.cornerRadius = 3.0;
//        [button addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = i;
//
//        i++;
//    }
        _alertView.layer.cornerRadius = 6;

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

- (id)initWithTitle:(NSMutableAttributedString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors{
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

@interface GJAlertWithDrawPassword ()<GJAlertViewPasswordDelegate>
@property(nonatomic,strong)GJAlertWithDrawViewPassword *gjAlertView;
@property(nonatomic,copy)GJAlertPasswordBlock alertTextBlock;

@end
@implementation GJAlertWithDrawPassword
- (id)initWithTitle:(NSMutableAttributedString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonClick:(void(^)(NSInteger buttonIndex , NSString * string))block{
    self = [super init];
    if (self) {
        self.gjAlertView = [[GJAlertWithDrawViewPassword alloc] initWithTitle:title message:message buttonTitles:buttonTitles buttonsColor:buttonColors];
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

    if (_DismissBlock) {
        _DismissBlock();
    }
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
 
