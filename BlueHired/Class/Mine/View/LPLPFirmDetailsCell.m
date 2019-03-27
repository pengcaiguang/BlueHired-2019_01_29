//
//  LPLPFirmDetailsCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLPFirmDetailsCell.h"


@implementation LPLPFirmDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.contentTF.delegate = self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (self.Row == 9) {
        NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        //匹配以0开头的数字
        NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
        //匹配两位小数、整数
        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
        return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] ? YES : NO;
    }
    return YES;

}

-(void)textFieldChanged:(UITextField *)textField{
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    int kMaxLength = 9999;
    
    if (self.Row == 0) {
//        if (textField.text.length >=12) {
//            textField.text = [textField.text substringToIndex:12];
//        }
        kMaxLength = 12;
    }else if (self.Row == 1){
//        if (textField.text.length >=120) {
//            textField.text = [textField.text substringToIndex:120];
//        }
        kMaxLength= 120;
    }else if (self.Row == 2){
//        if (textField.text.length >=11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
        kMaxLength = 11;
    }else if (self.Row == 3){
//        if (textField.text.length >=10) {
//            textField.text = [textField.text substringToIndex:10];
//        }
        kMaxLength = 10;
    }else if (self.Row == 4){
//        if (textField.text.length >=5) {
//            textField.text = [textField.text substringToIndex:5];
//        }
        kMaxLength = 5;
    }else if (self.Row == 5){
//        if (textField.text.length >=11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
        kMaxLength = 11;
    }else if (self.Row == 6){
//        if (textField.text.length >=10) {
//            textField.text = [textField.text substringToIndex:10];
//        }
        kMaxLength = 10;
    }else if (self.Row == 7){
//        if (textField.text.length >=15) {
//            textField.text = [textField.text substringToIndex:15];
//        }
        kMaxLength = 15;
    }else if (self.Row == 8){
//        if (textField.text.length >=11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
        kMaxLength = 11;
    }else if (self.Row == 9){
//        if (textField.text.length >=10) {
//            textField.text = [textField.text substringToIndex:10];
//        }
        kMaxLength = 10;
    }
    

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
    
    
    if (textField.text > 0) {
        if (self.block) {
            self.block(textField.text,self.Row);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
