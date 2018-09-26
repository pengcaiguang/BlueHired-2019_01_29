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


static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";


@interface LPSalarycCardBindVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordBgView;
@property (weak, nonatomic) IBOutlet UIButton *bingButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteCardButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePhoneButton;



@property(nonatomic,strong) LPSelectBindbankcardModel *model;

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *idcard;
@property(nonatomic,strong) NSString *card;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *password;

@property(nonatomic,strong) NSString *passwordString;
@property(nonatomic,assign) BOOL isHuanBang;

@end

@implementation LPSalarycCardBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工资卡绑定";
    
    self.isHuanBang = NO;
    
    self.nameTextField.delegate = self;
    self.idcardTextField.delegate = self;
    self.cardTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.deleteCardButton.hidden = YES;
    self.deletePhoneButton.hidden = YES;
    
    [self requestSelectBindbankcard];
}
-(void)setModel:(LPSelectBindbankcardModel *)model{
    _model = model;
    if (model.data) {
        self.passwordBgView.hidden = YES;
        self.nameTextField.text = model.data.userName;
        NSString *identityNoString = [RSAEncryptor decryptString:model.data.identityNo privateKey:RSAPrivateKey];
        self.idcardTextField.text = identityNoString;
        NSString *bankNumberString = [RSAEncryptor decryptString:model.data.bankNumber privateKey:RSAPrivateKey];
        self.cardTextField.text = bankNumberString;
        self.phoneTextField.text = model.data.bankUserTel;
        
        self.nameTextField.enabled = NO;
        self.idcardTextField.enabled = NO;
        self.cardTextField.enabled = NO;
        self.phoneTextField.enabled = NO;

        [self.bingButton setTitle:@"换绑" forState:UIControlStateNormal];
    }
    
}
- (IBAction)touchButton:(UIButton *)sender {
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
        if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
            [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.passwordTextField.text.length <= 0) {
            [self.view showLoadingMeg:@"请输入6位提现密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        [self requestBindunbindBankcard];
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
            if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
                [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
                return;
            }
            
        }else{
            GJAlertPassword *alert = [[GJAlertPassword alloc]initWithTitle:@"请输入提现密码，完成身份验证" message:nil buttonTitles:@[@"通过短信验证码方式完成身份验证"] buttonsColor:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex, NSString *string) {
                NSLog(@"%ld",buttonIndex);
                self.passwordString = string;
                [self requestUpdateDrawpwd];
                if (string.length != 6) {
                    LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            [alert show];
        }
    }
}


#pragma mark - textFieldDelegate
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
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.phoneTextField.text.length >= 11) {
            self.phoneTextField.text = [textField.text substringToIndex:11];
            return NO;
        }
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
    NSString *identityNoString = [RSAEncryptor encryptString:self.idcardTextField.text publicKey:RSAPublickKey];
    NSString *bankNumberString = [RSAEncryptor encryptString:self.cardTextField.text publicKey:RSAPublickKey];;
    
    NSDictionary *dic = @{
                          @"userName":self.nameTextField.text,
                          @"identityNo":identityNoString,
                          @"bankNumber":bankNumberString,
                          @"bankUserTel":self.phoneTextField.text,
                          @"moneyPassword":self.model.data ? @"" : self.passwordTextField.text,
                          @"type":self.model.data ? @"2" : @"1", //1绑定 2变更
                          };
    [NetApiManager requestBindunbindBankcardWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"res_msg"]) {
                    [self.view showLoadingMeg:responseObject[@"data"][@"res_msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
                    self.isHuanBang = YES;
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
