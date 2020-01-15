//
//  LPRegisterRankRecordCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRegisterRankRecordCell.h"

@implementation LPRegisterRankRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.AwardBtn.titleLabel.numberOfLines = 2;
    self.AwardBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.AwardBtn.layer.cornerRadius = LENGTH_SIZE(6);
    self.AwardBtn.layer.borderColor = [UIColor baseColor].CGColor;
    self.AwardBtn.layer.borderWidth = LENGTH_SIZE(1);
    [self.AwardBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPInviteRankListInviteRankModel *)model{
    _model = model;
    self.TimeLabel.text = [NSString convertStringToYYYNMM:model.time];
    self.numLabel.text = [NSString stringWithFormat:@"%ld人",(long)model.num.integerValue];
    if (model.rank.integerValue == 0) {
        self.RankLabel.text = @"未入榜";
        self.RankLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }else{
        self.RankLabel.text = [NSString stringWithFormat:@"第%ld名",(long)model.rank.integerValue];
        self.RankLabel.textColor = [UIColor baseColor];
    }
    self.AwardBtn.hidden = YES;
    self.AwardLabel.hidden = YES;
    //0没有奖励 1有奖励但没有领取 2已经领取
    if (model.status.integerValue == 0) {
        self.AwardLabel.hidden = NO;
        self.AwardLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.AwardLabel.text = @"无";
        
    }else if (model.status.integerValue == 1){
        self.AwardBtn.hidden = NO;
        [self.AwardBtn setTitle:[NSString stringWithFormat:@"领取\n%ld积分",(long)model.score.integerValue]
                       forState:UIControlStateNormal];
        
    }else if (model.status.integerValue == 2){
        self.AwardLabel.hidden = NO;
        self.AwardLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        self.AwardLabel.text = [NSString stringWithFormat:@"%ld积分",(long)model.score.integerValue];
    }
}
- (IBAction)TouchAward:(id)sender {
    if (self.model.status.integerValue == 1) {
        [self requestQueryinviteRankList];
    }
}

-(void)requestQueryinviteRankList{

    NSString *urlStr = [NSString stringWithFormat:@"invite/add_invite_score?inviteRankId=%@",self.model.id];
    
    [NetApiManager requestQueryinviteScore:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.model.status = @"2";
                    [self setModel:self.model];
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"领取成功" time:MESSAGE_SHOW_TIME];

                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"领取失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
