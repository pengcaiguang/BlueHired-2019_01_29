//
//  LPLPEntrySetDateVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLPEntrySetDateVC.h"

@interface LPLPEntrySetDateVC ()
@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;
@end

@implementation LPLPEntrySetDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置入职日期";
    self.userName.text = _model.userName;
    self.ClearBt.layer.cornerRadius = 5;
    self.ConfirmBt.layer.cornerRadius = 5;
    self.ClearBt.layer.borderWidth =1;
    self.ClearBt.layer.borderColor = [UIColor baseColor].CGColor;
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
    _datePicker.minimumDate = [NSDate dateWithTimeInterval:-72*60*60 sinceDate:[NSDate date]];
    _datePicker.maximumDate = [NSDate date];
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
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    
    [_setdate setTitle:dateString forState:UIControlStateNormal];
    [_setdate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self removeView];
}

- (IBAction)selectDate:(id)sender {
    [self alertView:1];
}
- (IBAction)touchClear:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)touchConfirm:(id)sender {
    if ([self.setdate.currentTitle isEqualToString:@"请选择入职日期"]) {
        [self.view showLoadingMeg:@"请选择入职日期！" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryUodateWorkDate];
}

#pragma mark - request
-(void)requestQueryUodateWorkDate{
    NSDictionary *dic = @{@"id":_model.id,
                          @"workBeginTime":self.setdate.currentTitle};
    
    [NetApiManager requestQueryUodateWorkDate:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                    if (self.BlockTL) {
                        self.BlockTL(self.model);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
