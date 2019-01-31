//
//  LPStoreBalanceCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPStoreBalanceCell.h"

@implementation LPStoreBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPWBalanceDataModel *)model
{
    _model = model;
    self.userName.text = [LPTools isNullToString:_model.userName];
    self.userNum.text = [LPTools isNullToString:_model.workNum];
    self.money.text =[LPTools isNullToString:_model.totalBonusMoney];
}

@end
