//
//  LPLabourCostEditVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLabourCostEditVC.h"

@interface LPLabourCostEditVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UITextField *MoneyTF;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@end

@implementation LPLabourCostEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.NameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.MoneyTF.delegate = self;
    if (self.Type == 1) {
        self.navigationItem.title = @"工价信息";
        self.NameLabel.text = @"工价名称";
        self.NameTF.placeholder  = @"请输入工价名称,例如普工";
        self.MoneyLabel.text = @"工价(元/小时)";
        self.MoneyTF.placeholder  = @"请输入工价";

        if (self.model) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(butClick:)];
            self.navigationItem.rightBarButtonItem = rightItem;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
            self.NameTF.text = self.model.priceName;
            self.MoneyTF.text =reviseString( self.model.priceMoney);
        }
    }else if (self.Type == 2){
        self.navigationItem.title = @"产品信息";
        self.NameLabel.text = @"产品名称";
        self.MoneyLabel.text = @"产品单价(元/件)";
        self.NameTF.placeholder  = @"请输入产品名称";
        self.MoneyTF.placeholder  = @"请输入产品单价";

        if (self.Promodel) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(butClick:)];
            self.navigationItem.rightBarButtonItem = rightItem;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
            self.NameTF.text = self.Promodel.productName;
            self.MoneyTF.text =reviseString( self.Promodel.productPrice);
        }
    }

 
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
 
    return YES;
}


- (void)textFieldChanged:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 10;
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




- (IBAction)TouchSave:(id)sender {
    if (self.Type == 1) {
        if (self.MoneyTF.text.floatValue == 0.0) {
            [self.view showLoadingMeg:@"请输入工价" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.NameTF.text.length == 0) {
            [self.view showLoadingMeg:@"请输入工价名称" time:MESSAGE_SHOW_TIME];
            return;
        }
        [self requestQueryUpdatePriceName];
    }else{
        if (self.MoneyTF.text.floatValue == 0.0) {
            [self.view showLoadingMeg:@"请输入产品单价" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.NameTF.text.length == 0) {
            [self.view showLoadingMeg:@"请输入产品名称" time:MESSAGE_SHOW_TIME];
            return;
        }
        [self requestQueryUpdateProList];
    }
}

-(void)butClick:(UIButton *)sender{
    if (self.Type == 1) {
        [self requestQueryDeletePriceName];
    }else{
        [self  requestQueryDeleteProList];
    }
}


#pragma mark - request
-(void)requestQueryUpdatePriceName{
    NSDictionary *dic = @{@"id":self.model.id?self.model.id:@"",
                          @"priceName":[LPTools removeSpaceAndNewline:self.NameTF.text],
                          @"priceMoney":self.MoneyTF.text
                          };
    [NetApiManager requestQueryUpdatePriceName:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (self.Block) {
                        self.Block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

#pragma mark - request
-(void)requestQueryUpdateProList{
    NSDictionary *dic = @{@"id":self.Promodel.id?self.Promodel.id:@"",
                          @"productName":[LPTools removeSpaceAndNewline:self.NameTF.text],
                          @"productPrice":self.MoneyTF.text
                          };
    [NetApiManager requestQueryUpdateProList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    if (self.Promodel.id) {
                        self.Promodel.productName = [LPTools removeSpaceAndNewline:self.NameTF.text];
                        self.Promodel.productPrice = self.MoneyTF.text;
                    }else{
                        LPProListDataModel *m = [[LPProListDataModel alloc] init];
                        m.id = responseObject[@"data"];
                        m.productName = [LPTools removeSpaceAndNewline:self.NameTF.text];
                        m.productPrice = self.MoneyTF.text;
                        
                        [self.listArray addObject:m];
                    }
                    if (self.Block) {
                        self.Block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}



-(void)requestQueryDeleteProList{
    NSDictionary *dic = @{@"id":self.Promodel.id?self.Promodel.id:@"",
                          @"delStatus":@(1)
                          };
    [NetApiManager requestQueryUpdateProList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] >0) {
                    [self.listArray removeObject:self.Promodel];
                    if (self.Block) {
                        self.Block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];

        }
        
    }];
}


-(void)requestQueryDeletePriceName{
    NSDictionary *dic = @{@"id":self.model.id?self.model.id:@"",
                          @"delStatus":@(1)
                          };
    [NetApiManager requestQueryUpdatePriceName:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0 ) {
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.Block) {
                        self.Block();
                    }
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

@end
