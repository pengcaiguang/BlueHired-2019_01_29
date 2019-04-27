//
//  LPDurationView.m
//  BlueHired
//
//  Created by peng on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPDurationView.h"

@interface LPDurationView ()


@property(nonatomic,strong) UILabel *titleLabel;


@property(nonatomic,strong) NSMutableArray *buttonArray;
@property(nonatomic,strong) NSMutableArray *typeButtonArray;

@property(nonatomic,strong) UIView *typebgView;
@property(nonatomic,strong) UIView *timebgView;


@property(nonatomic,assign) NSInteger selectIndex;

@end

@implementation LPDurationView


-(instancetype)init{
    self = [super init];
    if (self) {
        self.buttonArray = [NSMutableArray array];
        self.typeButtonArray = [NSMutableArray array];
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];

    }
    return self;
}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 1) {
        self.timebgView.hidden = YES;
        self.typebgView.hidden = NO;
    }else{
        self.timebgView.hidden = NO;
        self.typebgView.hidden = YES;
    }
}

-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(self.selectView.frame));
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
            [self clear];
            [self clearType];
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
-(void)hidden{
    self.hidden = YES;
}

-(void)touchTimeButton:(UIButton *)button{
    NSInteger index = button.tag;
    [self clear];
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    self.selectIndex = index;
}
-(void)touchTypeButton:(UIButton *)button{
    NSInteger index = button.tag;
    [self clearType];
    button.selected = YES;
    self.selectIndex = index;
    [self save];
}
-(void)clearType{
    for (UIButton *button in self.typeButtonArray) {
        button.selected = NO;
    }
}
-(void)clear{
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
}
-(void)save{
    if (self.block) {
        self.block(self.selectIndex);
    }
    [self hidden];
}

-(void)addTimeSubView{
    self.timebgView = [[UIView alloc]init];
    self.timebgView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 253-50);
    [self.selectView addSubview:self.timebgView];
    self.titleLabel.text = @"正常上班时长";
}
-(void)setTimeArray:(NSArray *)timeArray{
    _timeArray = timeArray;
    self.selectIndex = 0;
    for (UIView *view in self.timebgView.subviews) {
        [view removeFromSuperview];
    }
    self.buttonArray = [NSMutableArray array];

    self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 253);

    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 253-50);
    [self.timebgView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 51*ceil(self.timeArray.count/6.0));
    
    for (int i = 0; i < self.timeArray.count; i++) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(i%6 * SCREEN_WIDTH/6, floor(i/6)*51, SCREEN_WIDTH/6, 51);
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        
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
}

-(void)addTypeSubView{
    self.typebgView = [[UIView alloc]init];
    self.typebgView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 253-50);
    [self.selectView addSubview:self.typebgView];
    self.titleLabel.text = @"上班类型";
}
-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

-(void)setTypeArray:(NSArray *)typeArray{
    _typeArray = typeArray;
    self.selectIndex = 0;
    for (UIView *view in self.typebgView.subviews) {
        [view removeFromSuperview];
    }
    self.typeButtonArray = [NSMutableArray array];
    
    self.typebgView.frame = CGRectMake(0, 48, SCREEN_WIDTH, typeArray.count * 48);
    self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, typeArray.count * 48 + 48);
    
    for (int i = 0; i<self.typeArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake(0,48*i, SCREEN_WIDTH, 48);
        [button setTitle:self.typeArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(touchTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.typebgView addSubview:button];
        
        button.selected = i== self.selectIndex;
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0,48*i, SCREEN_WIDTH, 1)];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#FFDDDDDD"];
        [self.typebgView addSubview:lineV];

        [self.typeButtonArray addObject:button];
    }
}

#pragma mark - lazy
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
            make.height.mas_equalTo(48);
        }];
//        self.titleLabel.text = @"正常上班时长";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addTimeSubView];
        [self addTypeSubView];
        
        UIButton *cancelButton = [[UIButton alloc]init];
        [_selectView addSubview:cancelButton];
//        cancelButton.frame = CGRectMake(0, 253-47, SCREEN_WIDTH/2, 47);
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(47);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        cancelButton.hidden = YES;
        UIButton *saveButton = [[UIButton alloc]init];
        [_selectView addSubview:saveButton];
//        saveButton.frame = CGRectMake(SCREEN_WIDTH/2, 253-47, SCREEN_WIDTH/2, 47);
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(47);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        saveButton.backgroundColor = [UIColor whiteColor];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [saveButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        saveButton.hidden = YES;
    }
    return _selectView;
}
@end
