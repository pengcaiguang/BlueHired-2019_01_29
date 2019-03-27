//
//  LPConsumeTypeCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPConsumeTypeCell.h"

@implementation LPConsumeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPOverTimeAccountDataaccountListModel *)model{
    _model = model;
    _NameLable.text = model.accountName;
    _MoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.accountPrice.floatValue];
    _DetailsLabel.text = model.remark;
}

@end
