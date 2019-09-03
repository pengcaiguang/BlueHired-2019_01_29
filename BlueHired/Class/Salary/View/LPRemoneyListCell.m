//
//  LPRemoneyListCell.m
//  BlueHired
//
//  Created by iMac on 2019/8/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRemoneyListCell.h"

@implementation LPRemoneyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}
- (void)setModel:(LPReMoneyDrawDataModel *)model{
    _model = model;
    self.WorkName.text = model.mechanismName;
    self.InTime.text = [NSString stringWithFormat:@"入职日期：%@",[NSString convertStringToYYYMMDD:model.workBeginTime]];
    self.isShowDraw.hidden = model.prizeNum.integerValue>0?NO:YES;
}


@end
