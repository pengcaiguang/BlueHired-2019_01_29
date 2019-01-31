//
//  LPMineBillCell.m
//  BlueHired
//
//  Created by iMac on 2019/1/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMineBillCell.h"
#import "LPBillRecordVC.h"
#import "LPWithDrawalVC.h"

@implementation LPMineBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
}

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
 
     if (userMaterialModel.data.money) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：---";
    }
    _showMoneyButton.selected = NO;
    self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@",userMaterialModel.data.score ? userMaterialModel.data.score : @"--"];
}

- (IBAction)selectShowMoneyButton:(UIButton *)sender {
    if (!AlreadyLogin) {
        return;
    }
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：***";
    }
}


//个人账单
-(IBAction)touchbillRecordLabel:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPBillRecordVC *vc = [[LPBillRecordVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
//提现
-(IBAction)touchwithdrawalLabel:(id)sender{
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPWithDrawalVC *vc = [[LPWithDrawalVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.balance = self.userMaterialModel.data.money;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
