//
//  LPLeaveListCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLeaveListCell.h"

@implementation LPLeaveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(LPMonthWageDetailsDataleaveListModel *)model{
    _model = model;
    self.Name.text = [NSString stringWithFormat:@"%@(%@)",model.time,[NSString weekdayStringFromDate:model.time]];
    self.Money.text = [NSString stringWithFormat:@"%.2f/元",model.leaveMoneyTotal.floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
