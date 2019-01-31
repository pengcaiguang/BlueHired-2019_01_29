//
//  LPSalarycCardBindVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardBindVC.h"
#import "LPSelectBindbankcardModel.h"
#import "RSAEncryptor.h"
#import "NSString+Encode.h"
#import "LPSalarycCardBindPhoneVC.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "AddressPickerView.h"
static NSString *ERROT = @"ERROR";

static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";


@interface LPSalarycCardBindVC ()<UITextFieldDelegate,AddressPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordBgView;
@property (weak, nonatomic) IBOutlet UIButton *bingButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteCardButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *HintLabel;

@property (weak, nonatomic) IBOutlet UIView *SucceedView;


@property(nonatomic,strong) LPSelectBindbankcardModel *model;

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *idcard;
@property(nonatomic,strong) NSString *card;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *password;

@property(nonatomic,strong) NSString *passwordString;
@property(nonatomic,assign) BOOL isHuanBang;
@property(nonatomic,assign) BOOL isHuanBangcard;

@property(nonatomic,assign) NSInteger errorTimes;

@property (nonatomic ,strong) AddressPickerView * pickerView;

@end

@implementation LPSalarycCardBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工资卡绑定";
    
    self.isHuanBang = NO;
    self.ispass = NO;
    self.SucceedView.hidden = YES;
//    self.nameTextField.delegate = self;
    [self.nameTextField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.idcardTextField.delegate = self;
    self.cardTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.deleteCardButton.hidden = YES;
    self.deletePhoneButton.hidden = YES;
    
    [self requestSelectBindbankcard];
    [self.view addSubview:self.pickerView];

}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.ispass)
    {
        self.deleteCardButton.hidden = NO;
        self.deletePhoneButton.hidden = NO;
        self.cardTextField.enabled = YES;
        self.phoneTextField.enabled = YES;
        self.isHuanBang = YES;
    }
    
}

-(void)setModel:(LPSelectBindbankcardModel *)model{
    _model = model;
    if (model.data) {
        self.nameTextField.text = model.data.userName;
        NSString *identityNoString = [RSAEncryptor decryptString:model.data.identityNo privateKey:RSAPrivateKey];
        self.idcardTextField.text = identityNoString;
        NSString *bankNumberString = [RSAEncryptor decryptString:model.data.bankNumber privateKey:RSAPrivateKey];
        self.cardTextField.text = bankNumberString;
        self.phoneTextField.text = model.data.openBankAddr;
        
        if (bankNumberString.length!=0) {
            self.passwordBgView.hidden = YES;
            self.nameTextField.enabled = NO;
            self.idcardTextField.enabled = NO;
            self.cardTextField.enabled = NO;
            self.phoneTextField.enabled = NO;
            _isHuanBangcard = YES;
        }
        else
        {
            self.passwordBgView.hidden = NO;
            self.nameTextField.enabled = YES;
            self.idcardTextField.enabled = YES;
            self.cardTextField.enabled = YES;
            self.phoneTextField.enabled = YES;
            self.passwordTextField.enabled = YES;
            [self.bingButton setTitle:@"绑定" forState:UIControlStateNormal];
            _isHuanBangcard = NO;
             return;
        }
 
        [self.bingButton setTitle:@"换绑" forState:UIControlStateNormal];
    }
    
}
- (IBAction)touchButton:(UIButton *)sender {
    
    
        //                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *string = [dateFormatter stringFromDate:[NSDate date]];
        
        if (kUserDefaultsValue(ERROT)) {
            NSString *errorString = kUserDefaultsValue(ERROT);
            if(errorString.length<17){
                kUserDefaultsRemove(ERROT);
            }else{
                NSString *d = [errorString substringToIndex:16];
                NSString *t = [errorString substringFromIndex:17];
                NSString *str = [self dateTimeDifferenceWithStartTime:d endTime:string];
                self.errorTimes = [t integerValue];
                if ([t integerValue] >= 3 && [str integerValue] < 10) {
                    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请十分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                    }];
                    [alert show];
                    return;
                }else{
                    self.errorTimes = 0;
                    kUserDefaultsRemove(ERROT);
                }
            }
            
        }
    
    if (!self.model.data) {
        if (self.nameTextField.text.length <= 0) {
            [self.view showLoadingMeg:@"请输入持卡人姓名" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.idcardTextField.text.length <= 0 || ![NSString isIdentityCard:self.idcardTextField.text]) {
            [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
            [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.phoneTextField.text.length <= 0) {
//            [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
            [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.passwordTextField.text.length != 6) {
            [self.view showLoadingMeg:@"请输入6位提现密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        [self requestCardNOoccupy];
    }else{

        if (self.isHuanBang) {
            
            if (self.nameTextField.text.length <= 0) {
                [self.view showLoadingMeg:@"请输入持卡人姓名" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.idcardTextField.text.length <= 0 || ![NSString isIdentityCard:self.idcardTextField.text]) {
                [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
                [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.phoneTextField.text.length <= 0 ) {
//                [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
                
                [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
                return;
            }
            
            [self requestBindunbindBankcard];
        }else if (!self.isHuanBangcard){
            if (self.nameTextField.text.length <= 0) {
                [self.view showLoadingMeg:@"请输入持卡人姓名" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.idcardTextField.text.length <= 0 || ![NSString isIdentityCard:self.idcardTextField.text]) {
                [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
                [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.phoneTextField.text.length <= 0  ) {
//                [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
                            [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.passwordTextField.text.length != 6) {
                [self.view showLoadingMeg:@"请输入6位提现密码" time:MESSAGE_SHOW_TIME];
                return;
            }
            [self requestCardNOoccupy];
        } else{
            GJAlertPassword *alert = [[GJAlertPassword alloc]initWithTitle:@"请输入提现密码，完成身份验证" message:nil buttonTitles:@[@"通过短信验证码方式完成身份验证"] buttonsColor:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex, NSString *string) {
                NSLog(@"%ld",buttonIndex);
                self.passwordString = string;
                if (string.length != 6) {
                    LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                    vc.type = 2;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [self requestUpdateDrawpwd];
                }

            }];
            [alert show];
        }
    }
}

- (IBAction)touchBackBt:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.phoneTextField) {
//        self.CompanyTableView.hidden = !self.CompanyTableView.hidden;
//        self.bgView.hidden = self.CompanyTableView.hidden;
        [self.nameTextField resignFirstResponder];
        [self.idcardTextField resignFirstResponder];
        [self.cardTextField resignFirstResponder];
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.pickerView show];

        return NO;
    }
    return YES;
}

- (void)fieldTextDidChange:(UITextField *)textField

{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 6;
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
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.nameTextField.text.length >= 6) {
            self.nameTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    if (textField == self.idcardTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.idcardTextField.text.length >= 18) {
            self.idcardTextField.text = [textField.text substringToIndex:18];
            return NO;
        }
        return [self validateNumber:string];
    }
    if (textField == self.cardTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.cardTextField.text.length >= 19) {
            self.cardTextField.text = [textField.text substringToIndex:19];
            return NO;
        }
    }
    if (textField == self.phoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        }
//        //so easy
//        else if (self.phoneTextField.text.length >= 11) {
//            self.phoneTextField.text = [textField.text substringToIndex:11];
//            return NO;
//        }
    }
    if (textField == self.passwordTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.passwordTextField.text.length >= 6) {
            self.passwordTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
    
}
- (IBAction)touchDeleteCardButton:(id)sender {
    self.cardTextField.text = @"";
}
- (IBAction)touchDeletePhoneButton:(UIButton *)sender {
    self.phoneTextField.text = @"";
}

- (void)btnClick:(UIButton *)btn{
     if (btn.selected) {
        [self.pickerView show];
    }else{
        [self.pickerView hide];
    }
}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    if ([province isEqualToString:city]) {
        NSString *CityStr = [NSString stringWithFormat:@"%@",province];
        self.phoneTextField.text = CityStr;
    }else{
        NSString *CityStr = [NSString stringWithFormat:@"%@%@",province,city];
        self.phoneTextField.text = CityStr;
    }

    [self.pickerView hide];

//    [self btnClick:_addressBtn];
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:30 pickerViewHeight:276];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}

#pragma mark - request
-(void)requestSelectBindbankcard{
    [NetApiManager requestSelectBindbankcardWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPSelectBindbankcardModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestBindunbindBankcard{
    [self.nameTextField resignFirstResponder];
    [self.idcardTextField resignFirstResponder];
    [self.cardTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    NSString *identityNoString = [RSAEncryptor encryptString:self.idcardTextField.text publicKey:RSAPublickKey];
    NSString *bankNumberString = [RSAEncryptor encryptString:self.cardTextField.text publicKey:RSAPublickKey];;
    NSString *passwordString = [[NSString stringWithFormat:@"%@lanpin123.com",[self.passwordTextField.text md5]] md5];

    NSDictionary *dic ;
    if (_isHuanBangcard) {
        dic =  @{
                 @"userName":self.nameTextField.text,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.phoneTextField.text,
                 @"moneyPassword":self.model.data ? @"" : passwordString,
                 @"type":self.model.data ? @"2" : @"1", //1绑定 2变更
                 };
    }else{
        dic =  @{
                 @"userName":self.nameTextField.text,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.phoneTextField.text,
                 @"moneyPassword":passwordString,
                 @"type":self.model.data ? @"2" : @"1", //1绑定 2变更
                 };
    }

    [NetApiManager requestBindunbindBankcardWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"res_code"]) {
                    if ([responseObject[@"data"][@"res_code"] integerValue] == 0) {
                        if (responseObject[@"data"][@"res_msg"]) {
                            [self.view showLoadingMeg:responseObject[@"data"][@"res_msg"] time:2];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [self.navigationController popViewControllerAnimated:YES];
                                self.SucceedView.hidden = NO;
                            });
                            return ;
                        }
                    }
                }
                if (responseObject[@"data"][@"res_error_num"]) {
                    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"%@,剩余%@次机会",responseObject[@"data"][@"res_msg"],responseObject[@"data"][@"res_error_num"]] message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                    }];
                    [alert show];
                }else{
                    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"data"][@"res_msg"] message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert show];
                }
                

                
         
//                    [self.view showLoadingMeg:[NSString stringWithFormat:@"%@,剩余%@次机会",responseObject[@"data"][@"res_msg"],responseObject[@"data"][@"res_error_num"]?responseObject[@"data"][@"res_error_num"]:@"0"] time:2];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestCardNOoccupy{
    NSString *identityNoString = [RSAEncryptor encryptString:self.idcardTextField.text publicKey:RSAPublickKey];
    NSDictionary *dic = @{@"identityNo":identityNoString};
    [NetApiManager requestCardNOoccupy:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 20026) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"msg"] message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"取消",@"提交"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                    if (buttonIndex) {
                        [self requestBindunbindBankcard];
                    }
                }];
                [alert show];
            }else{
                if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    [self requestBindunbindBankcard];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)requestUpdateDrawpwd{
    
    NSString *passwordmd5 = [self.passwordString md5];
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
                    self.deleteCardButton.hidden = NO;
                    self.deletePhoneButton.hidden = NO;
                    self.cardTextField.enabled = YES;
                    self.phoneTextField.enabled = YES;
                    self.isHuanBang = YES;
                }else{
//                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                    
                    if (kUserDefaultsValue(ERROT)) {
                        NSString *errorString = kUserDefaultsValue(ERROT);
                        NSString *d = [errorString substringToIndex:16];
//                        if ([d isEqualToString:string]) {
                            NSString *t = [errorString substringFromIndex:17];
                            NSString *str = [self dateTimeDifferenceWithStartTime:d endTime:string];
                            self.errorTimes = [t integerValue];
                            if ([t integerValue] >= 3&& [str integerValue] < 10) {
                                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请十分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                                }];
                                [alert show];
                            }else{
                                NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
                                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"重试",@"忘记密码"] buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 1) {
                                        LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc]init];
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                }];
                                [alert show];
                                self.errorTimes += 1;
                                NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                                kUserDefaultsSave(str, ERROT);
                            }
//                        }else{
//                            NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
//                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"重试",@"忘记密码"] buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                                if (buttonIndex == 1) {
//                                    LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc]init];
//                                    [self.navigationController pushViewController:vc animated:YES];
//                                }
//                            }];
//                            [alert show];
//                            self.errorTimes += 1;
//                            NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
//                            kUserDefaultsSave(str, ERROT);
//                        }
                    }else{
                        NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"重试",@"忘记密码"] buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                        [alert show];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERROT);
                    }
                    //                    kUserDefaultsRemove(ERRORTIMES);
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

- (BOOL)validateNumber:(NSString*)number

{
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789X"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}


- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int minute = (int)value /60%60;
    //    int house = (int)value / (24 * 3600)%3600;
    //    int sum = house * 60 + minute + 1;
    NSString *str = [NSString stringWithFormat:@"%d",minute];
    return str;
}

@end
