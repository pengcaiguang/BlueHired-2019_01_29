//
//  LPRecreationInformationCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRecreationInformationCell.h"

@implementation LPRecreationInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.InformationImage.layer.cornerRadius = LENGTH_SIZE(6);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPRecreationEssayListModel *)model{
    _model = model;
    NSArray *imageArray = [model.essayUrl componentsSeparatedByString:@";"];

    [self.InformationImage yy_setImageWithURL:[NSURL URLWithString:imageArray[0]]
                                  placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E0E0E0"]]];
    self.InformationName.text = model.essayName;
    self.Time.text = [NSString stringWithFormat:@"发布时间：%@",[NSString convertStringToTime:model.time]];
}


@end
