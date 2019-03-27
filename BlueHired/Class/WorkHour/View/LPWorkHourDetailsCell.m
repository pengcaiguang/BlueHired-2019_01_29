//
//  LPWorkHourDetailsCell.m
//  BlueHired
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourDetailsCell.h"

@implementation LPWorkHourDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.DetailsBt.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
