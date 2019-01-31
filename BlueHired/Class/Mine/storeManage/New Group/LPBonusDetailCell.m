//
//  LPBonusDetailCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBonusDetailCell.h"

@implementation LPBonusDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(LPBonusDetailListModel *)model
{
    _model = model;
    
    [_userimage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
 
    _MechanismName.text = [LPTools isNullToString:model.mechanismName];
    _userName.text = [LPTools isNullToString:model.userName];
    _BonusMoney.text = [NSString stringWithFormat:@"提成金额: %@元",[LPTools isNullToString:model.bonusMoney]];
    _BonusNum.text = [NSString stringWithFormat:@"提成基数/单价: %@元/小时",[LPTools isNullToString:model.bonusNum]];
    _workTime.text = [NSString stringWithFormat:@"计费天数/工时: %@天",[LPTools isNullToString:model.workTime]];
    
    if (model.workTime.integerValue == 1) {
        _workType.text= @"小时工";
    }else{
        _workType.text= @"正式工";
    }
    
    
}


@end
