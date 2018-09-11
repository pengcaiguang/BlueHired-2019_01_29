//
//  LPDateSelectView.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPDateSelectView.h"

@interface LPDateSelectView()
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;

@end

@implementation LPDateSelectView

-(instancetype)init{
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];
        
    }
    return self;
}

-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 253);
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
        }];
    }else{
        self.bgView.hidden = NO;
        self.selectView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.1;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT-253, SCREEN_WIDTH, 253);
        }];
    }
}
-(void)hidden{
    self.hidden = YES;
}

#pragma mark - lazy
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 253)];
        _selectView.backgroundColor = [UIColor whiteColor];
        
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253)];
//        calendar.dataSource = self;
//        calendar.delegate = self;
        calendar.backgroundColor = [UIColor whiteColor];
        [_selectView addSubview:calendar];
        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
//        self.calendar = calendar;
        
    }
    return _selectView;
}
@end
