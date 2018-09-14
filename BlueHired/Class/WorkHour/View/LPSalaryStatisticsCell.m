//
//  LPSalaryStatisticsCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/14.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSalaryStatisticsCell.h"

@implementation LPSalaryStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.basicSalaryTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFieldChanged:(UITextField *)textField{
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
