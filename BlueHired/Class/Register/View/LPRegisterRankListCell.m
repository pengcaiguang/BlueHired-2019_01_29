//
//  LPRegisterRankListCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRegisterRankListCell.h"

@implementation LPRegisterRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(20);
    self.RankBtn.adjustsImageWhenHighlighted = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


- (void)setModel:(LPInviteRankListInviteRankModel *)model{
    _model = model;
    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
    self.UserName.text = model.userName;
    self.Num.text = [NSString stringWithFormat:@"%ld人",(long)model.num.integerValue];
}

@end
