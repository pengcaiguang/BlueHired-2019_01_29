//
//  LPScoreMoneyCell.m
//  BlueHired
//
//  Created by iMac on 2019/7/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreMoneyCell.h"

@implementation LPScoreMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

-(void)setModel:(LPGetScoreMoneyRecordDataModel *)model{
    _model = model;
    if (self.type == 1) {
        self.UserImage.hidden = YES;
        self.LayoutConstraint_UserName_Left.constant = LENGTH_SIZE(13);
        self.UserName.text = [NSString stringWithFormat:@"兑换金额：%.1f元",model.money.floatValue];
        self.Time.text = [NSString convertStringToTime:model.time];
        self.Money.text = [NSString stringWithFormat:@"-%ld积分",(long)model.score.integerValue];

    }else if (self.type == 2){
        self.UserImage.hidden = NO;
        self.LayoutConstraint_UserName_Left.constant = LENGTH_SIZE(61);
        [self.UserImage yy_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholder:[UIImage imageNamed:@"avatar"]];
        self.UserName.text = model.userName;
        self.Time.text = [NSString convertStringToTime:model.time];
        self.Money.text = [NSString stringWithFormat:@"兑换金额：%.1f元",model.money.floatValue];
    }
}

@end
