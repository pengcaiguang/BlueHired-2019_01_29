//
//  LPBusinessReviewCell.m
//  BlueHired
//
//  Created by peng on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBusinessReviewCell.h"

@implementation LPBusinessReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mechanismLogoImgView.layer.cornerRadius = 6;
    self.mechanismLogoImgView.layer.borderWidth = 0.5;
    self.mechanismLogoImgView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    
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
