//
//  LPMainCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMainCell.h"

@implementation LPMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.postNameLabel.layer.masksToBounds = YES;
    self.postNameLabel.layer.cornerRadius = 3.0;
    self.postNameLabel.layer.borderWidth = 0.5;
    self.postNameLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CAFFF"].CGColor;
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = 3.0;
    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CAFFF"].CGColor;
    
}

-(void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.mechanismName;
    if ([model.lendType integerValue] == 1) {
        self.lendTypeLabel.hidden = NO;
    }else{
        self.lendTypeLabel.hidden = YES;
    }
    
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.mechanismScore];
    
    self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    self.keyLabel.text = model.key;
    self.postNameLabel.text = model.postName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
