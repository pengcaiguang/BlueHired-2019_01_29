//
//  LPLendAuditAgreeVC.m
//  BlueHired
//
//  Created by iMac on 2019/1/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLendAuditAgreeVC.h"
#import "RSAEncryptor.h"
static NSString *TEXT = @"请输入审批金额理由...";
static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

@interface LPLendAuditAgreeVC ()<UITextViewDelegate>

@end

@implementation LPLendAuditAgreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"审核通过";
    NSString *certNoString = [RSAEncryptor decryptString:self.model.certNo privateKey:RSAPrivateKey];

    self.UserName.text = self.model.userName;
    self.CertNo.text = certNoString;
    self.LendMoney.text = self.model.lendMoney;
    [self.LendMoney addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    
    self.textview.layer.cornerRadius = 10;
    self.textview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textview.layer.borderWidth = 0.5;
    self.textview.textColor = [UIColor lightGrayColor];
    self.textview.text = TEXT;
    self.textview.delegate = self;
    
    self.TouchBt.layer.cornerRadius = 4;
}



-(void)textFieldChanged:(UITextField *)textField{
    
    
    if (textField.text.integerValue > self.model.lendMoney.integerValue) {
        textField.text = self.model.lendMoney;
    }
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
//    int kMaxLength = 4;
//
//    NSString *toBeString = textField.text;
//    // 获取键盘输入模式
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
//    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
//    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮选择部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > kMaxLength) {
//                // 截取子串
//                textField.text = [toBeString substringToIndex:kMaxLength];
//            }
//        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        }
//    } else {
//        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        if (toBeString.length > kMaxLength) {
//            // 截取子串
//            textField.text = [toBeString substringToIndex:kMaxLength];
//        }
//    }
    
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

- (IBAction)touchBt:(id)sender {
    if (self.LendMoney.text.integerValue==0) {
        [self.view showLoadingMeg:@"借支金额不能为0元"];
        return;
    }
    [self requestQueryUpdateMoneyList];
}
#pragma mark - request
-(void)requestQueryUpdateMoneyList{
    NSDictionary *dic = @{@"status":@"1",
                          @"money":self.LendMoney.text,
                          @"reason":[self.textview.textColor isEqual:[UIColor lightGrayColor]]?@"":self.textview.text,
                          @"id":self.model.id};
    
    [NetApiManager requestQueryUpdateLandMoneyList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                self.model.status = @"1";
                self.model.lendMoney = self.LendMoney.text;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
