//
//  LPEntryCertificationVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/6.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPEntryCertificationVC.h"

@interface LPEntryCertificationVC ()<UITextFieldDelegate>

@end

@implementation LPEntryCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"面试通过";
    
    _BMName.text = [LPTools isNullToString:_model.userName];
    _BMPhone.text = [LPTools isNullToString:_model.userTel];
    [self.name addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.Card.delegate = self;

 }


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.Card) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.Card.text.length >= 18) {
            self.Card.text = [textField.text substringToIndex:18];
            return NO;
        }
        return [self validateNumber:string];
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

- (IBAction)touchSender:(id)sender {
    NSString *name  = [_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *card  = [_Card.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (name.length== 0 ) {
        [self.view showLoadingMeg:@"请输入真实姓名" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (card.length== 0 ) {
        [self.view showLoadingMeg:@"请输入身份证号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (![NSString isIdentityCard:card]) {
        [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    [self requestQueryupdate_interview];
}

#pragma mark - request
-(void)requestQueryupdate_interview{
    
    NSString *name  = [_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *card  = [_Card.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSDictionary *dic = @{@"id":_model.id,
                          @"identityNo":card,
                          @"userName":name};
    
    [NetApiManager requestQueryupdate_interview:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                self.model.status = @"1";
                self.model.isReal = @"1";
                self.model.userName = self.name.text;
                if (self.Block) {
                    self.Block();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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


@end
