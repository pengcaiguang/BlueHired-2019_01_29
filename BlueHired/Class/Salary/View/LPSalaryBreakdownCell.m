//
//  LPSalaryBreakdownCell.m
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalaryBreakdownCell.h"

@implementation LPSalaryBreakdownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    
    self.DrawBt.layer.cornerRadius = 6;
    self.DrawBt.layer.borderColor = [UIColor baseColor].CGColor;
    self.DrawBt.layer.borderWidth = 1;
    [self.DrawBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
}
- (IBAction)touch:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
