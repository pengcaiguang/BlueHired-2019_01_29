//
//  LPSubsidyDeductionCell.m
//  BlueHired
//
//  Created by peng on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSubsidyDeductionCell.h"

@implementation LPSubsidyDeductionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
