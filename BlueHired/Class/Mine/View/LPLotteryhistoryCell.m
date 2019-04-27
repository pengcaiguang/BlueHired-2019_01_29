//
//  LPLotteryhistoryCell.m
//  BlueHired
//
//  Created by iMac on 2019/4/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLotteryhistoryCell.h"

@implementation LPLotteryhistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPLotteryDataModel *)model{
    _model = model;
    self.Date.text = [NSString stringWithFormat:@"第%@期",model.periodNum];

    self.Results.text = [model.winNum stringByReplacingOccurrencesOfString:@"," withString:@"  "];
    
}


@end
