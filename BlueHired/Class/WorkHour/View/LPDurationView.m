//
//  LPDurationView.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPDurationView.h"

@interface LPDurationView ()
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) NSArray *timeArray;
@property(nonatomic,strong) NSMutableArray *buttonArray;

@property(nonatomic,strong) NSString *selectString;

@end

@implementation LPDurationView


-(instancetype)init{
    self = [super init];
    if (self) {
        self.timeArray = @[@"0.5",@"1",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4",@"4.5",@"5",@"5.5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        self.buttonArray = [NSMutableArray array];
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];

    }
    return self;
}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 2) {
        self.titleLabel.text = @"正常上班时长";
        for (int i = 0; i < self.timeArray.count; i++) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(i%6 * SCREEN_WIDTH/6, floor(i/6)*51+50, SCREEN_WIDTH/6, 51);
            view.backgroundColor = [UIColor whiteColor];
            [_selectView addSubview:view];
            
            UIButton *button = [[UIButton alloc]init];
            [view addSubview:button];
            button.frame = CGRectMake((SCREEN_WIDTH/6-41)/2, 5, 41, 41);
            button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [button setTitle:self.timeArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20.5;
            button.tag = i;
            [self.buttonArray addObject:button];
            [button addTarget:self action:@selector(touchTimeButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        self.titleLabel.text = @"上班类型";
        NSArray *array = @[@"早班",@"中班",@"晚班"];
        for (int i = 0; i<3; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(0, 50 + 41*i, SCREEN_WIDTH, 41);
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#878787"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#1D1D1D"] forState:UIControlStateSelected];
            [_selectView addSubview:button];
        }
        
    }
}

-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 253);
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
            [self clear];
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

-(void)touchTimeButton:(UIButton *)button{
    NSInteger index = button.tag;
    [self clear];
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    self.selectString = self.timeArray[index];
}
-(void)clear{
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
}
-(void)save{
    if (self.block) {
        self.block(self.selectString);
    }
    [self hidden];
}

-(void)addTimeSubView{
    
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
        
        self.titleLabel = [[UILabel alloc]init];
        [_selectView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        self.titleLabel.text = @"正常上班时长";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//
//
//
//        for (int i = 0; i < self.timeArray.count; i++) {
//            UIView *view = [[UIView alloc]init];
//            view.frame = CGRectMake(i%6 * SCREEN_WIDTH/6, floor(i/6)*51+50, SCREEN_WIDTH/6, 51);
//            view.backgroundColor = [UIColor whiteColor];
//            [_selectView addSubview:view];
//
//            UIButton *button = [[UIButton alloc]init];
//            [view addSubview:button];
//            button.frame = CGRectMake((SCREEN_WIDTH/6-41)/2, 5, 41, 41);
//            button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//            [button setTitle:self.timeArray[i] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:16];
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 20.5;
//            button.tag = i;
//            [self.buttonArray addObject:button];
//            [button addTarget:self action:@selector(touchTimeButton:) forControlEvents:UIControlEventTouchUpInside];
//        }
        
        UIButton *cancelButton = [[UIButton alloc]init];
        cancelButton.frame = CGRectMake(0, 253-47, SCREEN_WIDTH/2, 47);
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:cancelButton];
        
        UIButton *saveButton = [[UIButton alloc]init];
        saveButton.frame = CGRectMake(SCREEN_WIDTH/2, 253-47, SCREEN_WIDTH/2, 47);
        saveButton.backgroundColor = [UIColor whiteColor];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [saveButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:saveButton];
    }
    return _selectView;
}
@end
