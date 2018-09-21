//
//  LPInfoCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoCell.h"

@implementation LPInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LPInfoListDataModel *)model{
    _model = model;
    if ([model.status integerValue] == 0) {
        self.statusImgView.image = [UIImage imageNamed:@"info_unread"];
    }else{
        self.statusImgView.image = [UIImage imageNamed:@"info_read"];
    }
    self.informationTitleLabel.text = model.informationTitle;
    self.informationDetailsLabel .text = model.informationDetails;
    self.timeLabel.text = [NSString convertStringToTime:[model.time stringValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
