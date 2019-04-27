//
//  LPSalaryStatisticsCell.m
//  BlueHired
//
//  Created by peng on 2018/9/14.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSalaryStatisticsCell.h"

@interface LPSalaryStatisticsCell()<UITextFieldDelegate>

@end

@implementation LPSalaryStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.basicSalaryTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.basicSalaryTextField.delegate = self;
}
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
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] ? YES : NO;
}


-(void)textFieldChanged:(UITextField *)textField{
    
    if (textField.text.length > 7) {
        textField.text = [textField.text substringToIndex:7];
        return;
    }
    if (textField.text > 0) {
        if (self.block) {
            self.block(textField.text);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
