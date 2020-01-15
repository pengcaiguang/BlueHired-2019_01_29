//
//  LPWorkInfoCell.m
//  BlueHired
//
//  Created by iMac on 2020/1/8.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import "LPWorkInfoCell.h"

@implementation LPWorkInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.TimeLabel.layer.cornerRadius = LENGTH_SIZE(9);
    self.TimeLabel.clipsToBounds = YES;
    
    self.BgView.backgroundColor = [UIColor whiteColor];
    self.BgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.BgView.layer.shadowOffset = CGSizeMake(0,0);
    self.BgView.layer.shadowOpacity = 1;
    self.BgView.layer.shadowRadius = 4;
    self.BgView.layer.cornerRadius = 6;
 
}


- (void)setModel:(LPInfoListDataModel *)model{
    _model = model;
    [self.WorkImage sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.TimeLabel.text = [NSString stringWithFormat:@"  %@  ",[NSString timeStringWithTimeInterval:model.time.stringValue]];
    self.TitleLabel.text = model.informationTitle;
    self.DetailsLabel.text = model.informationDetails;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
 
}

@end
