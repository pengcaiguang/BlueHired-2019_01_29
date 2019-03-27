//
//  LPWorkHourSetCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourSetCell.h"

@implementation LPWorkHourSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)SwitchTouch:(UISwitch *)sender {
    kUserDefaultsSave(sender.on?@"0":@"1", BOOK);
}

@end
