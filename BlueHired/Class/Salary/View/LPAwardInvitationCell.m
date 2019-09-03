//
//  LPAwardInvitationCell.m
//  BlueHired
//
//  Created by iMac on 2019/8/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAwardInvitationCell.h"
#import "LPInvitationDrawVC.h"

@implementation LPAwardInvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.drawBtn.layer.cornerRadius = LENGTH_SIZE(6);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPPrizeDataMoney *)model{
    _model = model;
    if (model.type.integerValue == 2) {
        self.InVitationTypeLable.text = @"邀请注册奖励";
    }else if (model.type.integerValue == 3){
        self.InVitationTypeLable.text = @"邀请入职奖励";
    }else if (model.type.integerValue == 4){
        self.InVitationTypeLable.text = @"分享点赞奖励";
    }
    
    self.InVitationMoneyLable.text = [NSString stringWithFormat:@"%.2f元",model.relationMoney.floatValue];
    self.UserNameLabel.text = model.type.integerValue == 4? [NSString stringWithFormat:@"入职企业：%@",model.mechanismName] : [NSString stringWithFormat:@"姓名：%@",model.userName];
    self.TimeLabel.text = [NSString stringWithFormat:@"奖励生成时间：%@",[NSString convertStringToYYYMMDD:model.setTime]];

    if (model.status.integerValue == 0) {
        self.drawBtn.layer.borderColor = [UIColor baseColor].CGColor;
        self.drawBtn.layer.borderWidth = 1;
        [self.drawBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [self.drawBtn setTitle:@"领取" forState:UIControlStateNormal];
        self.drawBtn.titleLabel.font = FONT_SIZE(15);
    }else{
        self.drawBtn.layer.borderColor = [UIColor clearColor].CGColor;
        self.drawBtn.layer.borderWidth = 0;
        [self.drawBtn setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        [self.drawBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.drawBtn.titleLabel.font = FONT_SIZE(14);
    }
}
- (IBAction)TouchDrawBtn:(id)sender {
    if (self.model.status.integerValue == 0) {
        LPInvitationDrawVC *vc = [[LPInvitationDrawVC alloc] init];
        vc.model = self.model;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

@end
