//
//  LPSalarycCardChangePasswordVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardChangePasswordVC.h"
#import "LPSalarycCardBindPhoneVC.h"

static NSString *ERRORTIMES = @"ERRORTIMES";

@interface LPSalarycCardChangePasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;
@property (weak, nonatomic) IBOutlet UIButton *phoneCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property(nonatomic,assign) NSInteger times;
@property(nonatomic,assign) NSInteger errorTimes;

@end

@implementation LPSalarycCardChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改提现密码";
    self.times = 0;
    self.errorTimes = 0;
    self.completeButton.hidden = YES;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.textColor = [UIColor clearColor];
    self.textField.tintColor = [UIColor clearColor];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    self.labelArray = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        [self.labelArray addObject:label];
        [self.textField addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
    }
    [self.labelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [self.labelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.textField becomeFirstResponder];
    NSMutableArray *viewarray = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"#AAAAAA"];
        [viewarray addObject:view];
        [self.textField addSubview:view];
    }
    [viewarray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:(SCREEN_WIDTH-46)/6-1 leadSpacing:0 tailSpacing:0];
    [viewarray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
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
    if (textField.text.length == 6) {
        if (self.times != 2) {
            [self requestUpdateDrawpwd];
        }
    }
}
#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.textField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.textField.text.length >= 6) {
            self.textField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}
- (IBAction)touchPhone:(UIButton *)sender {
    LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)touchCompleteButton:(id)sender {
    [self requestUpdateDrawpwd];
}

#pragma mark - request
-(void)requestUpdateDrawpwd{
    
    NSString *passwordmd5 = [self.textField.text md5];
    NSString *newpasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"oldPwd":newpasswordmd5,
                          };
    [NetApiManager requestUpdateDrawpwdWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"code"]) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    if (self.times == 2) {
                        [self.view showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }else{
                        self.times += 1;
                        self.phoneCodeButton.hidden = YES;
                        for (UILabel *label in self.labelArray) {
                            label.text = @"";
                        }
                        self.textField.text = @"";
                        if (self.times == 1) {
                            self.msgLabel.text = @"请输入新的提现密码";
                        }else{
                            self.msgLabel.text = @"请再次输入新的提现密码";
                            self.completeButton.hidden = NO;
                        }
                    }
                }else{
                    self.textField.text = @"";
                    for (UILabel *label in self.labelArray) {
                        label.text = @"";
                    }
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                    
                    if (kUserDefaultsValue(ERRORTIMES)) {
                        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
//                        NSString *d = [errorString substringToIndex:16];
                        NSString *t = [errorString substringFromIndex:17];
                        self.errorTimes = [t integerValue];
                        if ([t integerValue] >= 3) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请十分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert show];
                        }else{
                            [self.view showLoadingMeg:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",3-self.errorTimes] time:MESSAGE_SHOW_TIME];
                            self.errorTimes += 1;
                            NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                            kUserDefaultsSave(str, ERRORTIMES);
                        }
                    }else{
                        [self.view showLoadingMeg:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",3-self.errorTimes] time:MESSAGE_SHOW_TIME];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERRORTIMES);
                    }
//                    kUserDefaultsRemove(ERRORTIMES);
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
