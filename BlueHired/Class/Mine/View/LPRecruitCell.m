//
//  LPRecruitCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRecruitCell.h"
#import "LPRecruitRequireVC.h"

@interface LPRecruitCell ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;

@end

@implementation LPRecruitCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.number1.delegate = self;
    [self.number1 addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LPWork_ListDataModel *)model
{
    _model = model;
    [_image1 sd_setImageWithURL:[NSURL URLWithString:model.mechanismLogo] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    _GCName1.text = model.mechanismName;
    _Post1.text= model.postName;
    _WorkType1.text = model.workTypeName;
    _number1.text = model.maxNumber;
    NSArray *dateArr = [model.interviewTime componentsSeparatedByString:@"-"];
    if (dateArr.count==2) {
        [_startDate1 setTitle:dateArr[0] forState:UIControlStateNormal];
        [_endDate1 setTitle:dateArr[1] forState:UIControlStateNormal];
    }else if (dateArr.count == 1){
        [_startDate1 setTitle:dateArr[0] forState:UIControlStateNormal];
    }
    
    
    if (model.status.integerValue == 0) {
        _statueBt1.selected = YES;
        _statueBt2.selected = NO;
    }else{
        _statueBt1.selected = NO;
        _statueBt2.selected = YES;
    }
    
}


#pragma mark - textFieldDelegate


- (void)fieldTextDidChange:(UITextField *)textField

{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 5;

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
    self.model.maxNumber = textField.text;

    
}

-(BOOL)textField:( UITextField  *)textField shouldChangeCharactersInRange:(NSRange )range replacementString:( NSString  *)string
{
    if (range.length == 1 && string.length == 0) {
        self.model.maxNumber = textField.text;
        return YES;
    }
    
    if (_number1 == textField) {
        if (textField.text.length >= 5) {
            self.model.maxNumber = textField.text;
            return NO;
        }
    }
    return YES;
}

-(void)alertView:(NSInteger)index{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    self.popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
//    [self.popView addSubview:label];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,  10, SCREEN_WIDTH/2, 20)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.popView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,  10, SCREEN_WIDTH/2, 20)];
    confirmButton.tag = index;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);

    [self.popView addSubview:confirmButton];
    
    label.text = @"面试时间(时/分)";
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
    _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    _datePicker.calendar = [NSCalendar currentCalendar];
            [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//    _datePicker.locale = [NSLocale systemLocale];
    _datePicker.date = [NSDate date];
    //        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.popView addSubview:_datePicker];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
}

-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

-(void)confirmBirthday:(UIButton *)sender{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    if (sender.tag == 1) {
        [_startDate1 setTitle:dateString forState:UIControlStateNormal];
    }else if (sender.tag == 2){
        [_endDate1 setTitle:dateString forState:UIControlStateNormal];
    }
    self.model.interviewTime = [NSString stringWithFormat:@"%@-%@",_startDate1.currentTitle,_endDate1.currentTitle];
    [self removeView];
}


//招聘状态
- (IBAction)touchStatueBt:(UIButton *)sender {
        _statueBt2.selected = NO;
        _statueBt1.selected = NO;
        sender.selected = YES;
        self.model.status = _statueBt1.selected?@"0":@"1";
}
//发送
- (IBAction)TouchSenderBt:(id)sender {
    
    //时间比对
    
    
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请仔细检查您编辑的招聘信息，是否确定提交？" message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        NSLog(@"%ld",buttonIndex);
        if (buttonIndex) {
            [self requestQueryUpdateWorkList];
        }
        
    }];
    [alert show];
}

#pragma mark - request
-(void)requestQueryUpdateWorkList{
    
    NSDictionary *dic = [_model mj_keyValues];
    
    [NetApiManager requestQueryUpdateWorkList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIWindow visibleViewController].view showLoadingMeg:@"提交成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"提交失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//时间选择
- (IBAction)touchSelectDate:(UIButton *)sender {
    if (_startDate1 == sender) {
        [self alertView:1];
    }else if (_endDate1 == sender){
        [self alertView:2];
    }
}

- (IBAction)touchToRequire:(UIButton *)sender {
    LPRecruitRequireVC *vc = [[LPRecruitRequireVC alloc] init];
    vc.model = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

@end
