//
//  LPRegisterDetailCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisterDetailCell.h"

@implementation LPRegisterDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LPRegisterDetailDataListModel *)model{
    _model = model;
    self.userNameLabel.text = model.userName;
    if (model.type.integerValue == 0) {
        self.typeLabel.text = @"直接邀请";
    }else{
        self.typeLabel.text = @"间接邀请";
    }
    self.relationMoneyLabel.text = [NSString stringWithFormat:@"%@元",model.relationMoney];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
