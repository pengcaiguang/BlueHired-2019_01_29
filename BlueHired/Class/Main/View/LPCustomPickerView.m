//
//  LPCustomPickerView.m
//  BlueHired
//
//  Created by iMac on 2019/4/16.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPCustomPickerView.h"

@interface LPCustomPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong) UIPickerView *pickerView;


@end

@implementation LPCustomPickerView

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
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(self.selectView.frame));
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
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

-(void)save{
    if (self.block) {
        self.block([self.pickerView selectedRowInComponent:0]);
    }
    [self hidden];
}

- (void)setTypeArray:(NSArray *)typeArray{
    _typeArray = typeArray;
    [self.pickerView reloadAllComponents];

}


#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.typeArray count];
 }

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
 
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = [self.typeArray objectAtIndex:row];
//    text.textColor = [UIColor baseColor];
    [view addSubview:text];
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    return view;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [self.typeArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor baseColor]} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
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
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,  10, SCREEN_WIDTH/2, 20)];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [self.selectView addSubview:cancelButton];
        
        UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,  10, SCREEN_WIDTH/2, 20)];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [self.selectView addSubview:confirmButton];
        
        
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self.selectView addSubview:pickerView];
        self.pickerView = pickerView;
        [self.pickerView reloadAllComponents];
        
        
        
        
    }
    return _selectView;
}

@end
