//
//  LPActivityCell.m
//  BlueHired
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPActivityCell.h"
#import "LPActivityDatelisVC.h"

@implementation LPActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ActivityBT.layer.cornerRadius = 11;
}

- (void)setModel:(LPActivityDataModel *)model{
    _model = model;
    [self.BGImage sd_setImageWithURL:[NSURL URLWithString:model.activityUrl] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    self.TitleLabel.text = [LPTools isNullToString:model.activityName];
    self.DateLabel.text = [NSString stringWithFormat:@"活动时间：%@ — %@",[NSString convertStringToYYYMMDD:model.activityBeginTime],[NSString convertStringToYYYMMDD:model.activityEndTime]];
    if (model.countDownTime.integerValue>0) {
        self.ActivityBT.backgroundColor = [UIColor whiteColor];
        [self.ActivityBT setTitleColor:[UIColor colorWithHexString:@"#FFFF5F30"] forState:UIControlStateNormal];
        [self.ActivityBT setTitle:@"立即参与" forState:UIControlStateNormal];
    }else{
        self.ActivityBT.backgroundColor = [UIColor colorWithHexString:@"#FFDDB3AA"];
        [self.ActivityBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.ActivityBT setTitle:@"活动已结束" forState:UIControlStateNormal];
    }
}

- (IBAction)touchBt:(id)sender {
    LPActivityDatelisVC *vc = [[LPActivityDatelisVC alloc] init];
    vc.Model = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
