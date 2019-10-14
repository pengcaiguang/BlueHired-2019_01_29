//
//  LPScoreStoreBillCell.m
//  BlueHired
//
//  Created by iMac on 2019/9/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoreBillCell.h"

@implementation LPScoreStoreBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPScoreStoreBillDataModel *)model{
    _model = model;
    self.TypeLabel.text = model.type.intValue ? @"积分退还":@"商品兑换";
    self.TimeLabel.text = [NSString convertStringToTime:model.time];
    self.ScoreLabel.text = [NSString stringWithFormat:@"%@%@积分",model.type.intValue ? @"+" : @"-" ,model.score];
}


@end
