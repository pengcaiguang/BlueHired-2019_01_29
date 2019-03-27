//
//  LPTypeWorkHourView.m
//  BlueHired
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPTypeWorkHourView.h"

@interface LPTypeWorkHourView()
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;
@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation LPTypeWorkHourView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];
        
    }
    return self;
}

-(void)hidden{
    self.hidden = YES;
}

-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(self.selectView.frame));
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
            //            [self clear];
            //            [self clearType];
        }];
    }else{
        self.bgView.hidden = NO;
        self.selectView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(self.selectView.frame), SCREEN_WIDTH, CGRectGetHeight(self.selectView.frame));
        }];
    }
}
-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 453)];
        _selectView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc]init];
        [_selectView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        self.titleLabel.text = @"2018-07-04·周一";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _selectView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

@end
