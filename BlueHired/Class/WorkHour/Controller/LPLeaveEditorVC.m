//
//  LPLeaveEditorVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLeaveEditorVC.h"
static NSString *TEXT = @"可以备注您请假的原因，最多30字!";

@interface LPLeaveEditorVC ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation LPLeaveEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"请假编辑(%@)",self.model.time];
    self.Money1.text = reviseString(self.model.leaveMoney);
    self.Money2.text = reviseString(self.model.hours);
    self.Money1.delegate = self;
    self.Money2.delegate = self;
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 4;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    if (self.model.remark.length == 0) {
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = TEXT;
    }else{
        self.textView.text = [LPTools isNullToString:self.model.remark];
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(butClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
    
}

#pragma mark - tagter
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //匹配以0开头的数字
    NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
    //匹配两位小数、整数
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7? YES : NO;
}

#pragma mark - TextViewDelegate

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

//当编辑时动态判断是否超过规定字数，这里限制30字
- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.textView) {
        //        if (textView.text.length > 30) {
        //            textView.text = [textView.text substringToIndex:30];
        //        }
        /**
         *  最大输入长度,中英文字符都按一个字符计算
         */
        static int kMaxLength = 30;
        
        NSString *toBeString = textView.text;
        // 获取键盘输入模式
        NSString *lang = [textView.textInputMode primaryLanguage];
        // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
        // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮选择部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > kMaxLength) {
                    // 截取子串
                    textView.text = [toBeString substringToIndex:kMaxLength];
                }
            } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        } else {
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }
    
}



-(void)butClick{        //删除
    [self requestQueryDeleteOvertime];
}
- (IBAction)SaveTouch:(id)sender {
    if (self.Money1.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请输入请假单价" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.Money2.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请输入请假时间" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryGetOvertime];
}



-(void)requestQueryDeleteOvertime{
 
    NSDictionary  *dic = @{@"id":self.model.id,
                           @"delStatus":@(1),
                           @"type":@(self.WorkHourType)
                           };
    
    WEAK_SELF();
    [NetApiManager requestQueryGetOvertime:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray  *dataArr = [responseObject[@"data"] componentsSeparatedByString:@"#"];//分隔符逗号
                if ([dataArr[1] integerValue] == 1) {
                    if (self.block) {
                        self.block(1);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}


-(void)requestQueryGetOvertime{
    
    NSInteger leaveTime = self.Money2.text.floatValue *60;
    NSString *remarkStr =@"";
    if (![self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
        if (self.textView.text.length>30) {
            remarkStr = [self.textView.text substringToIndex:30];
        }else{
            remarkStr = self.textView.text;
        }
    }
    
    NSDictionary  *dic = @{@"id":self.model.id,
                            @"status":@(2),
                           @"leaveTime":@(leaveTime),
                            @"leaveMoney":[NSString stringWithFormat:@"%.2f",self.Money1.text.floatValue],
                            @"remark":remarkStr,
                            @"type":@(self.WorkHourType),
                            };
 
    WEAK_SELF();
    [NetApiManager requestQueryGetOvertime:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray  *dataArr = [responseObject[@"data"] componentsSeparatedByString:@"#"];//分隔符逗号
                if ([dataArr[1] integerValue] == 1) {
                    weakSelf.model.leaveTime = [NSString stringWithFormat:@"%ld",(long)leaveTime];
                    weakSelf.model.hours = [NSString stringWithFormat:@"%.2f",leaveTime/60.0];
                    weakSelf.model.leaveMoney = weakSelf.Money1.text;
                    weakSelf.model.leaveMoneyTotal = [NSString stringWithFormat:@"%.2f",weakSelf.model.hours.floatValue*weakSelf.model.leaveMoney.floatValue];
                    weakSelf.model.remark = remarkStr;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    if (self.SuperTableView) {
                        [self.SuperTableView reloadData];
                    }
                    if (self.block) {
                        self.block(2);
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];

        }
        
    }];
}


@end
