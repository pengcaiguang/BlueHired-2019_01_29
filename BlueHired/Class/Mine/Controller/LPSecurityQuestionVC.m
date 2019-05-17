//
//  LPSecurityQuestionVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPSecurityQuestionVC.h"
#import "RSAEncryptor.h"
#import "LPChangePhoneVC.h"
#import "AppDelegate.h"
#import "LPSetSecretVC.h"

static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

static NSString *WXAPPID = @"wx566f19a70d573321";

@interface LPSecurityQuestionVC ()<LPWxLoginHBDelegate>
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel2;
@property (weak, nonatomic) IBOutlet UITextField *issueTF;
@property (weak, nonatomic) IBOutlet UITextField *issueTF2;

@property (nonatomic,strong) LPUserProblemModel *model;
@property (nonatomic,strong) NSString *Openid;
@property (nonatomic,strong) LPUserMaterialModel *userData;
@end

@implementation LPSecurityQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密保问题";
    [self.issueTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.issueTF2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self requestQueryGetUserProdlemList];

    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.WXdelegate = self;
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    self.userData = user;
    self.Openid = [LPTools isNullToString:user.data.openid];;

}


#pragma mark - LPWxLoginHBBack
- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo{
    if (![self.Openid isEqualToString:wxUserInfo.unionid]) {
        NSDictionary *dic = @{
                              @"sgin":[LPTools isNullToString:wxUserInfo.unionid],
                              @"phone":self.userData.data.userTel,
                              @"userUrl":[LPTools isNullToString:wxUserInfo.headimgurl],
                              @"userName":@"0fc23ce3bc0e1ee5e5e"
                              };
        [NetApiManager requestQueryWXSetPhone:dic withHandle:^(BOOL isSuccess, id responseObject) {
            NSLog(@"%@",responseObject);
            if (isSuccess) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"] integerValue] > 0) {
                        if ([self.Openid isEqualToString:@""]) {
                            [self.view showLoadingMeg:@"绑定成功" time:MESSAGE_SHOW_TIME];
                        }else{
                            [self.view showLoadingMeg:@"换绑成功，请之后用新微信号进行登录！" time:MESSAGE_SHOW_TIME];
                        }
                        self.userData.data.openid = wxUserInfo.unionid;
                        //                    self.WXLabel.text = @"已绑定";
                        [self.navigationController   popToRootViewControllerAnimated:YES];
                    }else{
                        [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"注册失败" time:MESSAGE_SHOW_TIME];
                    }
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
               
            }else{
                [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
            }
        }];
    }else{
        [self.view showLoadingMeg:@"此次微信号与之前绑定的一致，请更换微信号重试！" time:MESSAGE_SHOW_TIME];
    }
    
}


-(void)textFieldChanged:(UITextField *)textField{
    //        if (textView.text.length > 30) {
    //            textView.text = [textView.text substringToIndex:30];
    //        }
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 10;
    
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [textField.textInputMode primaryLanguage];
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
- (void)setModel:(LPUserProblemModel *)model{
    _model = model;
    
    if (self.model.data.count==2) {
        NSString *problemName1 = self.model.data[0].problemName;
        NSString *problemName2 = self.model.data[1].problemName;
        
//        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:problemName1 options:0];
//        problemName1 = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
//
//        NSData *decodedData2 = [[NSData alloc] initWithBase64EncodedString:problemName2 options:0];
//
//        problemName2 = [[NSString alloc] initWithData:decodedData2 encoding:NSUTF8StringEncoding];

//       problemName1 =  [problemName1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//       problemName2 =  [problemName2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


        self.issueLabel.text = [LPTools isNullToString:problemName1];
        self.issueLabel2.text = [LPTools isNullToString:problemName2];
    }
    
    
}

- (IBAction)TouchToService:(UIButton *)sender {
    sender.enabled = NO;
    [self requestQueryGetCustomerTel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}


- (IBAction)TouchSave:(id)sender {
    self.issueTF.text = [self.issueTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.issueTF2.text = [self.issueTF2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.issueTF.text.length == 0 && self.issueTF2.text.length == 0) {
        [self.view showLoadingMeg:@"请输入问题答案" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryVerifyUserProdlemList];
}

#pragma mark - request
-(void)requestQueryVerifyUserProdlemList{
    
    
//    NSString *strIssueBt1 = [[self.issueLabel.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    NSString *strIssueTF1 = [[self.issueTF.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    NSString *strIssueBt2 = [[self.issueLabel2.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    NSString *strIssueTF2 = [[self.issueTF2.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    
    
    NSArray *dictArray = @[@{@"problemName" : self.issueLabel.text,
                             @"problemAnswer" : self.issueTF.text},
                           @{@"problemName" : self.issueLabel2.text,
                             @"problemAnswer" : self.issueTF2.text}];
    
    NSDictionary *dic = @{@"userProblemList":dictArray};
    //    NSLog(@"%@",dic);
    WEAK_SELF()
    [NetApiManager requestQueryVerifyUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ( [responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"验证通过" time:MESSAGE_SHOW_TIME];
                    if (self.type == 4) {
                        [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
                                                            State:@"123x"
                                                           OpenID:WXAPPID
                                                 InViewController:self];
                    }else if (self.type == 2){
                        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc] init];
                        vc.type = 3;
                        vc.Newtype = 2;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else if (self.type == 1){
                        LPSetSecretVC *vc = [[LPSetSecretVC alloc]init];
                        //                                vc.model = self.model;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                    //                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"验证失败,请重新输入" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetCustomerTel{
    NSDictionary *dic = @{};
    //    NSLog(@"%@",dic);

    [NetApiManager requestQueryGetCustomerTel:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",responseObject[@"data"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetUserProdlemList{
    
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPUserProblemModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
