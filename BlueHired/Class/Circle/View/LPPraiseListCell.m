//
//  LPPraiseListCell.m
//  BlueHired
//
//  Created by iMac on 2018/12/22.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPPraiseListCell.h"

@implementation LPPraiseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImage.layer.cornerRadius = 16.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LPPraiseDataModel *)model{
    _model = model;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.gradingImage.image = [UIImage imageNamed:model.grading];
    self.userName.text = [LPTools isNullToString:model.userName];
}

@end
