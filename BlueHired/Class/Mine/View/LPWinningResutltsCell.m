//
//  LPWinningResutltsCell.m
//  BlueHired
//
//  Created by iMac on 2019/4/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWinningResutltsCell.h"

@implementation LPWinningResutltsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(LPLotteryDataModel *)model{
    _model = model;
    self.Date.text = [NSString stringWithFormat:@"第%@期",model.periodNum];
    self.luckyNum.text = [NSString stringWithFormat:@"%@",model.luckyNum];
    self.Score.text = [NSString stringWithFormat:@"%@",model.getScore];
    
    if (model.status.integerValue == 1) {
        self.Date.textColor = [UIColor colorWithHexString:@"#FC3A91"];
        self.luckyNum.textColor = [UIColor colorWithHexString:@"#FC3A91"];
        self.status.textColor = [UIColor colorWithHexString:@"#FC3A91"];
        self.Score.textColor = [UIColor colorWithHexString:@"#FC3A91"];
        
        self.status.text = @"已中奖";
    }else if (model.status.integerValue == 2){
        self.Date.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.luckyNum.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.status.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.Score.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.status.text = @"未中奖";
    }else if (model.status.integerValue == 0){
        self.Date.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.luckyNum.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.status.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.Score.textColor = [UIColor colorWithHexString:@"#615C66"];
        self.status.text = @"等待开奖";

    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
