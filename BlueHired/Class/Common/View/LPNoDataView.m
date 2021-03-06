//
//  LPNoDataView.m
//  BlueHired
//
//  Created by peng on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPNoDataView.h"
#import "LPLoginVC.h"

@interface LPNoDataView ()

@property(nonatomic,strong) UIButton *LoginBt;

@end

@implementation LPNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        [self updateUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self updateUI];
    }
    return self;
}
-(void)image:(UIImage *)image text:(NSString *)text{
    if (image) {
        self.imageView.image = image;
    }
    if (text) {
        self.label.text = text;
    }
}

- (void)setIsShowLoginBt:(BOOL)isShowLoginBt{
    _LoginBt.hidden = isShowLoginBt;
}

-(void)updateUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-15);

    }];
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(self.imageView.mas_bottom).offset(LENGTH_SIZE(14));
    }];
    
    [self addSubview:self.LoginBt];
    [self.LoginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.width.mas_equalTo(LENGTH_SIZE(140));
        make.top.equalTo(self.label.mas_bottom).offset(LENGTH_SIZE(38));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"search_empty"];
        
    }
    return _imageView;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.numberOfLines = 0;
        _label.textColor = [UIColor colorWithHexString:@"#444444"];
        _label.font = [UIFont systemFontOfSize:FontSize(14)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"搜不到您要的结果，换个关键词试试哦～";
    }
    return _label;
}

-(UIButton *)LoginBt{
    if (!_LoginBt) {
        _LoginBt = [[UIButton alloc] init];
        _LoginBt.backgroundColor = [UIColor baseColor];
        [_LoginBt setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_LoginBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _LoginBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
         _LoginBt.layer.cornerRadius = LENGTH_SIZE(6);
        [_LoginBt addTarget:self action:@selector(ToLoginView) forControlEvents:UIControlEventTouchUpInside];
        _LoginBt.hidden = YES;
    }
    return _LoginBt;
}

-(void)ToLoginView{
//    [LoginUtils validationLogin:[UIWindow visibleViewController]];
    LPLoginVC *vc = [[LPLoginVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isCircleVC = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

@end
