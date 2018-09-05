//
//  LPBusinessReviewCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBusinessReviewCell.h"

@implementation LPBusinessReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//@property (weak, nonatomic) IBOutlet UIImageView *mechanismLogoImgView;
//@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *mechanismAddressLabel;
//@property (weak, nonatomic) IBOutlet UILabel *mechanismScoreLabel;

-(void)setModel:(LPMechanismcommentMechanismlistDataModel *)model{
    _model = model;
    [self.mechanismLogoImgView sd_setImageWithURL:[NSURL URLWithString:model.mechanismLogo]];
    self.mechanismNameLabel.text = model.mechanismName;
    self.mechanismAddressLabel.text = model.mechanismAddress;
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%.1f分",model.mechanismScore.floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end