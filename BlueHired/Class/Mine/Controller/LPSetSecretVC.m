//
//  LPSetSecretVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPSetSecretVC.h"
#import "LPSortAlertView.h"
#import "LPUserProblemModel.h"
#import "LPAccountManageVC.h"
#import "RSAEncryptor.h"
#import "LPMineVC.h"


static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";


@interface LPSetSecretVC ()<LPSortAlertViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *IssueBt1;
@property (weak, nonatomic) IBOutlet UITextField *IssueTF1;
@property (weak, nonatomic) IBOutlet UIButton *IssueBt2;
@property (weak, nonatomic) IBOutlet UITextField *IssueTF2;

@property(nonatomic,strong) LPSortAlertView *sortAlertView;

@property (nonatomic,strong) NSArray *IssueList;
@property (nonatomic,strong) NSArray *TempIssueList;
@property (nonatomic,strong) UIButton *SelectBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Left;



@end

@implementation LPSetSecretVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"密保设置";
    
    self.IssueBt1.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    self.IssueBt1.layer.borderWidth = 0.5;
    self.IssueTF1.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    self.IssueTF1.layer.borderWidth = 0.5;
    self.IssueBt2.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    self.IssueBt2.layer.borderWidth = 0.5;
    self.IssueTF2.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    self.IssueTF2.layer.borderWidth = 0.5;
    
    [self.IssueBt1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.IssueBt2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    self.IssueTF1.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    self.IssueTF2.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    self.IssueTF1.leftViewMode = UITextFieldViewModeAlways;
    self.IssueTF2.leftViewMode = UITextFieldViewModeAlways;

 
    [self.IssueTF1 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.IssueTF2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    if (SCREEN_WIDTH == 320) {
        self.LayoutConstraint_Left.constant = 6.0;
        self.IssueBt1.titleLabel.font = [UIFont systemFontOfSize:14];
        self.IssueBt2.titleLabel.font = [UIFont systemFontOfSize:14];
        self.IssueTF1.font = [UIFont systemFontOfSize:14];
        self.IssueTF2.font = [UIFont systemFontOfSize:14];

    }else{
        self.LayoutConstraint_Left.constant = 20.0;
        self.IssueBt1.titleLabel.font = [UIFont systemFontOfSize:16];
        self.IssueBt2.titleLabel.font = [UIFont systemFontOfSize:16];
        self.IssueTF1.font = [UIFont systemFontOfSize:16];
        self.IssueTF2.font = [UIFont systemFontOfSize:16];
    }
    
    self.IssueList = @[@"您最喜欢的城市?",
                       @"您最看爱看的电影或电视剧?",
                       @"您最喜欢的书?",
                       @"您的曾用名是什么?",
                       @"您伴侣的姓名是什么?",
                       @"您孩子的姓名是什么?"];
    
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

- (IBAction)TouchIssue1:(UIButton *)sender {
    self.sortAlertView.touchButton = sender;
    sender.selected = !sender.isSelected;
    
    NSMutableArray *mArrat = [[NSMutableArray alloc] initWithArray:self.IssueList];
    [mArrat removeObject:self.IssueBt2.currentTitle];
    self.sortAlertView.titleArray  = [mArrat copy];
    self.sortAlertView.hidden =  !sender.isSelected;

    _SelectBt = sender;
    _TempIssueList = [mArrat copy];
}

- (IBAction)TouchIssue2:(UIButton *)sender {
    self.sortAlertView.touchButton = sender;
    sender.selected = !sender.isSelected;
    
    NSMutableArray *mArrat = [[NSMutableArray alloc] initWithArray:self.IssueList];
    [mArrat removeObject:self.IssueBt1.currentTitle];
    self.sortAlertView.titleArray  = [mArrat copy];
    self.sortAlertView.hidden =  !sender.isSelected;

    _SelectBt = sender;
    _TempIssueList = [mArrat copy];
}



- (IBAction)TouchSave:(id)sender {
    self.IssueTF1.text = [self.IssueTF1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.IssueTF2.text = [self.IssueTF2.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (self.IssueBt1.currentTitle.length == 0) {
        [self.view showLoadingMeg:@"请选择问题1" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.IssueBt2.currentTitle.length == 0) {
        [self.view showLoadingMeg:@"请选择问题2" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.IssueTF1.text.length == 0) {
        [self.view showLoadingMeg:@"请输入问题1答案" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.IssueTF2.text.length == 0) {
        [self.view showLoadingMeg:@"请输入问题2答案" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    [self requestQueryUpdateUserProdlemList];
    
}

#pragma mark - LPSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{

    [self.SelectBt setTitle:self.TempIssueList[index] forState:UIControlStateNormal];

}

#pragma mark - lazy
-(LPSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPSortAlertView alloc]init];
//        _sortAlertView.touchButton = self.VideoLabel;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}


#pragma mark - request
-(void)requestQueryUpdateUserProdlemList{
 
//    NSString *strIssueBt1 = [[self.IssueBt1.currentTitle dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    NSString *strIssueTF1 = [[self.IssueTF1.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    NSString *strIssueBt2 = [[self.IssueBt2.currentTitle dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    NSString *strIssueTF2 = [[self.IssueTF2.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];

    
    NSArray *dictArray = @[@{@"problemName" : self.IssueBt1.currentTitle,
                             @"problemAnswer" : self.IssueTF1.text},
                           @{@"problemName" : self.IssueBt2.currentTitle,
                             @"problemAnswer" : self.IssueTF2.text}];
    
    NSDictionary *dic = @{@"userProblemList":dictArray};
//    NSLog(@"%@",dic);
    WEAK_SELF()
    [NetApiManager requestQueryUpdateUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                [self.view showLoadingMeg:@"设置成功" time:MESSAGE_SHOW_TIME];
//                LPAccountManageVC *vc = [[LPAccountManageVC alloc] init];
                [self.navigationController popToRootViewControllerAnimated:YES];
//                NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
//                NSMutableArray *naviVCsArr2 = [[NSMutableArray alloc] init];
//
//                for (UIViewController *vc in naviVCsArr) {
//                    if ([vc isKindOfClass:[LPMineVC class]]) {
//                        [naviVCsArr2 addObject:vc];
////                        break;
//                    }
//                }
//                [naviVCsArr2 addObject:vc];
//                vc.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController  setViewControllers:naviVCsArr2 animated:YES];

            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
