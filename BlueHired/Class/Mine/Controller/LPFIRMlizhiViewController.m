//
//  LPFIRMlizhiViewController.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPFIRMlizhiViewController.h"

static NSString *TEXT = @"请输入离职的原因";

@interface LPFIRMlizhiViewController ()<UITextViewDelegate>
@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;
@end

@implementation LPFIRMlizhiViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = TEXT;
    self.textView.delegate = self;
    _DetailsModel.workEndType = @"1";

    self.navigationItem.title = @"离职信息";
}

- (IBAction)touchselectDateBt:(id)sender {
    [self alertView:0];
    [self.view endEditing:YES];
}



-(void)alertView:(NSInteger)index{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0;
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
    
    label.text = @"请选择入职日期";
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
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

-(void)confirmBirthday:(UIButton *)sender{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    
    [_dateBt setTitle:dateString forState:UIControlStateNormal];
    [_dateBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self removeView];
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



-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.textColor isEqual:[UIColor lightGrayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = TEXT;
    }
}


- (IBAction)TouchStatus:(UIButton *)sender {
    _statusBt1.selected = NO;
    _statusBt2.selected = NO;
    
    sender.selected = YES;
    if (_statusBt1.selected) {
        _DetailsModel.workEndType = @"1";
    }else
    {
        _DetailsModel.workEndType = @"2";
    }
    
}



- (IBAction)TouchUpdate:(id)sender {
    if (self.textView.text.length == 0 ||
        [self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
        [self.view showLoadingMeg:@"请输入原因" time:MESSAGE_SHOW_TIME];
        return;
    }
    if ([_dateBt.currentTitle isEqualToString:@"请输入离职日期（如:2018-02-12）"]) {
        [self.view showLoadingMeg:@"请输入离职日期！" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    
    if (self.textView.text.length >= 600 ) {
        [self.view showLoadingMeg:@"字数过长,请限定在600字以内" time:MESSAGE_SHOW_TIME];
        return;
    }
    _DetailsModel.workEndTime = _dateBt.currentTitle;
    _DetailsModel.workEndDetails = self.textView.text;
//    [self requestQueryUpdateUserRegistration];
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)requestQueryUpdateUserRegistration{
    NSDictionary *dic = [self.DetailsModel mj_keyValues];
    
    WEAK_SELF()
    [NetApiManager requestQueryUpdateUserRegistration:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [weakSelf.view showLoadingMeg:@"操作成功" time:MESSAGE_SHOW_TIME];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
